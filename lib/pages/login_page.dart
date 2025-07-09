import 'package:absensiq/pages/password_page.dart';
import 'package:absensiq/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool viewPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: 400,
              height: 289,
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                  image: AssetImage('assets/images/ppkd.jpg'),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: SizedBox(
                  child: Column(
                    children: [
                      Text(
                        'Hallo!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Please login to get full access from us',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xB3ffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                alignment: Alignment.topLeft,
                color: Colors.white,
                height: 180,
                width: 330,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username', style: TextStyle(color: Colors.black)),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Color(0xff000000),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0x66000000)),
                            hintText: 'Alfarezhi Mohamad Rasidan',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(4, 4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(4, 4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(color: Color(0xff000000)),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText: !viewPassword,
                            cursorColor: Color(0xff000000),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color(0x66000000)),
                              hintText: '•••••••••••••',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(4, 4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(4, 4),
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    viewPassword = !viewPassword;
                                  });
                                },
                                icon: Icon(
                                  viewPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            buildLoginButton(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lupa Kata Sandi?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PasswordPage.id);
                  },
                  child: Text(
                    'Reset Password',
                    style: TextStyle(color: Color(0xff113289)),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum Punya Akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.id);
                  },
                  child: Text(
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

  Container buildLoginButton() {
    return Container(
      width: 330,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff113289),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
          ),
        ),
        child: Text('Login', style: TextStyle(color: Color(0xffffffff))),
      ),
    );
  }
}
