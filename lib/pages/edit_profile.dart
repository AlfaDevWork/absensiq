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
          CustomTextFormField(label: 'Nama', hintText: 'Alfarezhi'),
        ],
      ),
    );
  }
}
