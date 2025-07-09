import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: Color(0xff113289),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              'Register Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama', style: TextStyle(color: Colors.black)),
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
                ],
              ),
            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama', style: TextStyle(color: Colors.black)),
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
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 100,
              width: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password', style: TextStyle(color: Color(0xff000000))),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    // obscureText: !viewPassword,
                    cursorColor: Color(0xff000000),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0x66000000)),
                      hintText: '•••••••••••••',
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            // viewPassword = !viewPassword;
                          });
                        },
                        icon: Icon(
                          // viewPassword
                          // ? Icons.visibility_off_outlined
                          // :
                          Icons.visibility_outlined,
                          // color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ],
              ),
            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Laki-laki'),
                    value: 'L',
                    groupValue: _selectedGender,
                    onChanged: (v) => setState(() => _selectedGender = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Perempuan'),
                    value: 'P',
                    groupValue: _selectedGender,
                    onChanged: (v) => setState(() => _selectedGender = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
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
                  'Login',
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
