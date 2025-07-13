import 'package:absensiq/pages/auths/reset_password.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ChangePasswordRequestPage extends StatefulWidget {
  final String email;
  const ChangePasswordRequestPage({super.key, required this.email});

  @override
  State<ChangePasswordRequestPage> createState() =>
      _ChangePasswordRequestPageState();
}

class _ChangePasswordRequestPageState extends State<ChangePasswordRequestPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleSendOtp() async {
    setState(() => _isLoading = true);
    try {
      final response = await _authService.forgotPassword(email: widget.email);
      if (mounted) {
        final message = response['message'] ?? 'OTP berhasil dikirim!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordPage(email: widget.email, popOnSucces: true),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
      appBar: AppBar(
        title: const Text('Ubah Kata Sandi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.email_outlined,
              size: 80,
              color: Color(0xff113289).withOpacity(0.8),
            ),
            const SizedBox(height: 24),
            Text(
              'Kirim Kode Konfirmasi',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Kami akan mengirimkan kode OTP untuk konfirmasi ke email Anda yang terdaftar:\n',
                  ),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff113289),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: 'Kirim Kode OTP',
                    onPressed: _handleSendOtp,
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
