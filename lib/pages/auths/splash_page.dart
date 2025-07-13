import 'package:absensiq/pages/auths/login_page.dart';
import 'package:absensiq/pages/navigation.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  Future<void> changePage() async {
    await Future.delayed(Duration(seconds: 2));
    final String? token = await _authService.getToken();
    if (mounted) {
      if (token != null) {
        Navigator.of(context).pushReplacementNamed(NavigationPage.id);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    changePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 50),
            SizedBox(height: 10),
            Text('AbsensiQ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
