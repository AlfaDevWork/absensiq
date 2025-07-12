import 'package:absensiq/models/user.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  static const String id = "/edit_profile";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait({_authService.getUserProfile()});

      if (mounted) {
        setState(() {
          _user = results[0];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ubah Profil'), centerTitle: true),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(child: CircleAvatar(radius: 50)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: 'Nama',
                          hintText: _user?.name ?? 'Nama Pengguna',
                        ),
                        SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'Email',
                          hintText: _user?.email ?? 'Email Pengunna',
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
