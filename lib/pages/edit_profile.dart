import 'package:absensiq/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  static const String id = "/edit_profile";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ubah Profil'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(child: CircleAvatar(radius: 50)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
            child: Column(
              children: [
                CustomTextFormField(label: 'Nama', hintText: 'Alfarezhi'),
                SizedBox(height: 10),
                CustomTextFormField(label: 'Email', hintText: 'Email'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
