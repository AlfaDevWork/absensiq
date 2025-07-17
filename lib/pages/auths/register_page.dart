import 'package:absensiq/models/batch.dart';
import 'package:absensiq/models/training.dart';
import 'package:absensiq/pages/auths/login_page.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/custom_search_dropdown.dart';
import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';

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

  bool _viewPassword = false;
  bool _isLoading = false;
  bool _isDataLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final batches = await _authService.getBatches();
      final trainings = await _authService.getTrainings();
      if (mounted) {
        setState(() {
          _batches = batches;
          _trainings = trainings;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Gagal memuat data: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDataLoading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Jenis kelamin harus dipilih')));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await _authService.register(
        name: _namaController.text,
        email: _emailController.text,
        password: _passwordController.text,
        jenisKelamin: _selectedGender!,
        batchId: _selectedBatch!.id.toString(),
        trainingId: _selectedTraining!.id.toString(),
      );

      if (mounted) {
        final message = response['message'] ?? 'Registrasi berhasil!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(message),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(e.toString()),
          ),
        );
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
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text('Buat Akun', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: const Color(0xff113289),
        elevation: 1,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: _isDataLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
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
                          Text(
                            'Pelatihan',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomDropdownSearch<Training>(
                            hintText: 'Pilih Pelatihan',
                            items: _trainings,
                            selectedItem: _selectedTraining,
                            itemLabel: (training) => training.title,
                            onChanged: (Training? data) =>
                                setState(() => _selectedTraining = data),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Batch',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomDropdownSearch(
                            hintText: 'Pilih Batch',
                            items: _batches,
                            selectedItem: _selectedBatch,
                            itemLabel: (batch) => batch.batchKe.toString(),
                            onChanged: (Batch? data) =>
                                setState(() => _selectedBatch = data),
                          ),
                          SizedBox(height: 10),
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
                                  onChanged: (v) =>
                                      setState(() => _selectedGender = v),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Perempuan'),
                                  value: 'P',
                                  groupValue: _selectedGender,
                                  onChanged: (v) =>
                                      setState(() => _selectedGender = v),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () {
                                      _handleRegister();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff113289),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.elliptical(4, 4),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah Punya Akun?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginPage.id);
                                },
                                child: const Text(
                                  'Masuk Sekarang',
                                  style: TextStyle(color: Color(0xff113289)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
