import 'package:absensiq/pages/absen_page.dart';
import 'package:absensiq/pages/auths/forgot_password.dart';
import 'package:absensiq/pages/auths/login_page.dart';
import 'package:absensiq/pages/auths/register_page.dart';
import 'package:absensiq/pages/auths/reset_password.dart';
import 'package:absensiq/pages/edit_profile.dart';
import 'package:absensiq/pages/home_page.dart';
import 'package:absensiq/pages/navigation.dart';
import 'package:absensiq/pages/profile_page.dart';
import 'package:absensiq/pages/riwayat_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        NavigationPage.id: (context) => NavigationPage(),
        HomePage.id: (contect) => HomePage(),
        ProfilePage.id: (contect) => ProfilePage(),
        RiwayatPage.id: (contect) => RiwayatPage(),
        AbsenPage.id: (context) => AbsenPage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        ForgotPasswordPage.id: (context) => ForgotPasswordPage(),
        ResetPasswordPage.id: (context) => ResetPasswordPage(),
        EditProfilePage.id: (context) => EditProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      // home: LoginPage(),
    );
  }
}
