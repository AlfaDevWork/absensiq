import 'package:absensiq/pages/auths/register_page.dart';
import 'package:absensiq/pages/auths/reset_password.dart';
import 'package:absensiq/pages/navigation.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _viewPassword = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        final message = response['message'] ?? 'Login Berhasil';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(context).pushNamedAndRemoveUntil(
          NavigationPage.id,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black45,
                    BlendMode.darken,
                  ),
                  image: AssetImage('assets/images/ppkd.jpg'),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hallo!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Please login to get full access from us',
                    style: TextStyle(fontSize: 14, color: Color(0xB3ffffff)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
              child: Column(
                children: [
                  CustomTextFormField(
                    label: 'Email',
                    hintText: 'Masukkan email Anda',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Email tidak boleh kosong';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v))
                        return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    label: 'Password',
                    hintText: '•••••••••••••',
                    controller: _passwordController,
                    obscureText: !_viewPassword,
                    validator: (v) =>
                        v!.isEmpty ? ' Password tidak boleh kosong' : null,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              _handleLogin();
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
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Lupa Kata Sandi?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ResetPasswordPage.id);
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(color: Color(0xff113289)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum Punya Akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.id);
                  },
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(color: Color(0xff113289)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
