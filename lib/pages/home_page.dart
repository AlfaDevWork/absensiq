import 'dart:math';

import 'package:absensiq/constant/app_color.dart';
import 'package:absensiq/models/attendance_record.dart';
import 'package:absensiq/models/user.dart';
import 'package:absensiq/pages/riwayat_page.dart';
import 'package:absensiq/services/attendance_service.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:absensiq/widgets/attendance_history_card.dart';
import 'package:absensiq/widgets/izin_history_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final AttendanceService _attendanceService = AttendanceService();

  User? _user;
  String _checkInTime = "-";
  String _checkOutTime = "-";
  String _distance = "-";
  List<AttendanceRecord> _attendanceHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  final LatLng _officeLocation = const LatLng(
    -6.2108407743659555,
    106.81292008239214,
  );

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _authService.getUserProfile(),
        _attendanceService.getTodayAttendance(),
        _attendanceService.getAttendanceHistory(),
        _getCurrentPosition(),
      ]);

      if (mounted) {
        setState(() {
          _user = results[0] as User;

          final todayAttendance = results[1] as Map<String, dynamic>;
          if (todayAttendance['data'] != null) {
            final data = todayAttendance['data'];
            _checkInTime = data['check_in_time'] ?? '-';
            _checkOutTime = data['check_out_time'] ?? '-';
          }

          _attendanceHistory = results[2] as List<AttendanceRecord>;

          final currentPosition = results[3] as Position?;
          if (currentPosition != null) {
            final distanceInMeters = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              _officeLocation.latitude,
              _officeLocation.longitude,
            );
            _distance = '${distanceInMeters.toStringAsFixed(2)}m';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return null;
        }
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 19) return 'Selamat Sore';
    return 'Selamat Malam';
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
              onRefresh: _loadAllData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColor.main,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 17,
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 11,
                                      top: 17,
                                    ),
                                    child: Text(
                                      'Jl. Karet Pasar Baru Barat, Karet Tengsin, Kecamatan Tanah Abang, Kota Jakarta Pusat',
                                      style: TextStyle(color: Colors.white),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Container(
                                width: 300,
                                height: 67,
                                decoration: BoxDecoration(
                                  color: Color(0x21113289),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Check In',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            _checkInTime,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      indent: 6,
                                      endIndent: 6,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Check Out',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            _checkOutTime,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Container(
                        // width: 350,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0x3084BFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Distance from place'),
                                Text(
                                  _distance,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Riwayat Kehadiran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RiwayatPage.id);
                            },
                            child: Text(
                              'Lihat Semua',
                              style: TextStyle(color: Color(0xff113289)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _attendanceHistory.isEmpty
                        ? Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 24),
                            child: Center(
                              child: Text('Belum ada riwayat kehadiran'),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: min(3, _attendanceHistory.length),
                            itemBuilder: (BuildContext context, int index) {
                              final record = _attendanceHistory[index];
                              if (record.status.toLowerCase() == 'izin') {
                                return IzinHistoryCard(record: record);
                              } else {
                                return AttendanceHistoryCard(record: record);
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Row _buildHeader() {
    final profileImage =
        _user?.profilePhotoUrl != null && _user!.profilePhotoUrl!.isNotEmpty
        ? NetworkImage(_user!.profilePhotoUrl!)
        : AssetImage('assets/images/noprofilepicture.jpg') as ImageProvider;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 78, left: 28),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.lightBlueAccent,
            foregroundImage: profileImage,
            onForegroundImageError: (e, s) {},
            child: Icon(Icons.person, size: 28, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 70, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()} ${_user?.name ?? 'Nama Pengguna'}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Text(
                  DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                ),
                SizedBox(height: 3),
                Text(
                  '${_user?.trainingTitle ?? 'Pelatihan'} - Batch ${_user?.batchKe ?? ''}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
