import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const String id = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 72),
                  child: CircleAvatar(radius: 50),
                ),
                SizedBox(height: 12),
                Text('Alfarezhi Mohamad Rasidan'),
                Text('123456789'),
              ],
            ),
          ),
          SizedBox(height: 42),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Ubah Profil'),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Ubah Kata Sandi'),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Keluar'),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
