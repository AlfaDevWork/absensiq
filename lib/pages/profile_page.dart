import 'package:absensiq/models/user.dart';
import 'package:absensiq/pages/auths/change_password_request_screen.dart';
import 'package:absensiq/pages/auths/login_page.dart';
import 'package:absensiq/pages/edit_profile.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const String id = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = await _authService.getUserProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : RefreshIndicator(
              onRefresh: _fetchUserProfile,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 35),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Ubah Profil'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                      onTap: () async {
                        if (_user != null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(currentUser: _user!),
                            ),
                          );
                          if (result == true) {
                            _fetchUserProfile();
                          }
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Ubah Kata Sandi'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChangePasswordRequestPage(email: _user!.email),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Keluar'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              'Keluar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text('Apakah Anda yakin ingin keluar?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _authService.logout();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginPage.id,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Keluar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
    );
  }

  Center _buildHeader() {
    final profileImage =
        _user?.profilePhotoUrl != null && _user!.profilePhotoUrl!.isNotEmpty
        ? NetworkImage(_user!.profilePhotoUrl!)
        : const AssetImage('assets/images/noprofilepicture.jpg')
              as ImageProvider;

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 72),
            child: Container(
              decoration: ShapeDecoration(
                shape: CircleBorder(side: BorderSide(color: Colors.black)),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                foregroundImage: profileImage,
                onForegroundImageError: (exception, stackTrace) {},
                child: const Icon(Icons.person, size: 75, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            _user?.name ?? 'Nama Pengguna',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_user?.trainingTitle ?? 'Pelatihan'} - Batch ${_user?.batchKe ?? ''}',
          ),
        ],
      ),
    );
  }
}
