import 'dart:io';

import 'package:absensiq/models/batch.dart';
import 'package:absensiq/models/training.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/textformfield.dart'; // Pastikan path ini benar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Batch> _batches = [];
  List<Training> _trainings = [];

  Batch? _selectedBatch;
  Training? _selectedTraining;

  String? _selectedGender;
  // File? _profileImage;

  bool _viewPassword = false;
  final AuthService _authService = AuthService();
  // final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'Register Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff113289),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  controller: _namaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  label: 'Email',
                  hintText: 'Masukkan alamat email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  label: 'Password',
                  hintText: '•••••••••••••',
                  controller: _passwordController,
                  obscureText: !_viewPassword,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _viewPassword = !_viewPassword;
                      });
                    },
                    icon: Icon(
                      _viewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Jenis Kelamin",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Laki-laki'),
                        value: 'L',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Perempuan'),
                        value: 'P',
                        groupValue: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedGender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan pilih jenis kelamin'),
                            ),
                          );
                          return;
                        }
                        print("Nama: ${_namaController.text}");
                        print("Email: ${_emailController.text}");
                        print("Password: ${_passwordController.text}");
                        print("Gender: $_selectedGender");
                        // Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff113289),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
