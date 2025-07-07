import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 190),
                Text('Login', style: TextStyle(fontSize: 40)),
                Text("Let's get started", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    title: 'test',
                    prefixIcon: Icon(Icons.email),
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
