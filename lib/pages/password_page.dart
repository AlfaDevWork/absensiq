import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  static const String id = "/password";

  @override
  State<PasswordPage> createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(fontSize: 14, color: Color(0xB3ffffff)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Reset Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Text('Anda akan menerima notifikasi melalui email anda'),
          ),
          Center(
            child: Container(
              alignment: Alignment.topLeft,
              color: Colors.white,
              height: 100,
              width: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email', style: TextStyle(color: Colors.black)),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Color(0xff000000),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0x66000000)),
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
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
                child: Text(
                  'Send to Email',
                  style: TextStyle(color: Color(0xffffffff)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
