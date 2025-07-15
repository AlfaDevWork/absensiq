import 'dart:io';

import 'package:absensiq/models/user.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/custom_button.dart';
import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;
  const EditProfilePage({super.key, required this.currentUser});
  static const String id = "/edit_profile";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  User? _user;
  bool _isLoading = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _emailController = TextEditingController(text: widget.currentUser.email);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    String? successMessage;

    try {
      final textResponse = await _authService.updateUserProfile(
        name: _nameController.text,
        email: _emailController.text,
      );
      successMessage = textResponse['message'];

      if (_profileImage != null) {
        final photoResponse = await _authService.updateProfilePhoto(
          photo: _profileImage!,
        );
        successMessage = photoResponse['message'];
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage ?? 'Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Ubah Profil'),
        centerTitle: true,
        surfaceTintColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfilePicker(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _nameController,
                    label: 'Nama',
                    hintText: _user?.name ?? 'Nama Pengguna',
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: _user?.email ?? 'Email Pengunna',
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: 'Simpan Perubahan',
                          onPressed: _handleUpdateProfile,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicker() {
    ImageProvider currentImage;
    if (_profileImage != null) {
      currentImage = FileImage(_profileImage!);
    } else if (widget.currentUser.profilePhotoUrl != null &&
        widget.currentUser.profilePhotoUrl!.isNotEmpty) {
      currentImage = NetworkImage(widget.currentUser.profilePhotoUrl!);
    } else {
      currentImage =
          const AssetImage('assets/images/noprofilepictu.png') as ImageProvider;
    }

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              foregroundImage: currentImage,
              onForegroundImageError: (exception, stackTrace) {},
              child: const Icon(Icons.person, size: 75, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(
              Icons.camera_alt_outlined,
              size: 20,
              color: Color(0xff113289),
            ),
            label: const Text(
              'Ubah Foto Profil',
              style: TextStyle(color: Color(0xff113289)),
            ),
          ),
        ],
      ),
    );
  }
}
