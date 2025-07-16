import 'dart:async';

import 'package:absensiq/constant/app_color.dart';
import 'package:absensiq/pages/izin_page.dart';
import 'package:absensiq/services/attendance_service.dart';
import 'package:absensiq/widgets/custom_action_button.dart';
import 'package:absensiq/widgets/watermark.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});
  static const String id = "/absen";

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  final AttendanceService _attendanceService = AttendanceService();

  String _currentAddress = "Mencari lokasi...";
  String _status = "Memuat...";
  String _checkInTime = '-';
  String _checkOutTime = '-';
  DateTime? _attendanceDate;
  bool _isLoadingLocation = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;

  Position? _currentPosition;
  final Set<Marker> _markers = {};

  static final LatLng _officeLocation = LatLng(-6.1753924, 106.8271528);

  Future<void> _initialize() async {
    await _getCurrentLocation();
    await _getTodayAttendance();
  }

  Future<void> _getTodayAttendance() async {
    try {
      final result = await _attendanceService.getTodayAttendance();
      if (mounted && result['data'] != null) {
        setState(() {
          final data = result['data'];
          _status = data['status'] ?? 'Belum Check In';
          _attendanceDate = data['attendance_date'] != null
              ? DateTime.parse(data['attendance_date'])
              : DateTime.now();
          _checkInTime = data['check_in_time'] ?? '-';
          _checkOutTime = data['check_out_time'] ?? '-';
          _hasCheckedIn = data['check_in_time'] != null;
          _hasCheckedOut = data['check_out_time'] != null;
        });
      } else {
        setState(() {
          _status = 'Belum Check In';
          _hasCheckedIn = false;
          _hasCheckedOut = false;
          _checkInTime = '-';
          _checkOutTime = '-';
          _attendanceDate = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _errorMessage = e.toString();
        });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw 'Izin lokasi ditolak.';
      }
      if (permission == LocationPermission.deniedForever)
        throw 'Izin lokasi ditolak permanen.';

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Tidak dapat menemukan alamat.";
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = "${place.street}, ${place.subLocality}, ${place.locality}";
      }

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _currentAddress = address;
        _markers.add(
          Marker(
            markerId: const MarkerId('CurrentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Lokasi Anda'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.5,
          ),
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleCheckIn() async {
    if (_currentPosition == null) {
      _showSnackBar('Lokasi saat ini tidak ditemukan.', isError: true);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final result = await _attendanceService.checkIn(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _currentAddress,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        time: DateFormat('HH:mm').format(DateTime.now()),
      );
      _showSnackBar(result['message'] ?? 'Absen masuk berhasil!');

      // PERBAIKAN: Langsung perbarui state UI setelah berhasil untuk mencegah double tap
      setState(() {
        _hasCheckedIn = true;
        _status = 'Masuk';
        _checkInTime = DateFormat('HH:mm').format(DateTime.now());
      });
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleCheckOut() async {
    if (_currentPosition == null) {
      _showSnackBar('Lokasi saat ini tidak ditemukan.', isError: true);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final result = await _attendanceService.checkOut(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _currentAddress,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        time: DateFormat('HH:mm').format(DateTime.now()),
      );
      _showSnackBar(result['message'] ?? 'Absen pulang berhasil!');

      // PERBAIKAN: Langsung perbarui state UI setelah berhasil
      setState(() {
        _hasCheckedOut = true;
        _checkOutTime = DateFormat('HH:mm').format(DateTime.now());
      });
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text('Kehadiran'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _officeLocation,
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_mapController.isCompleted) {
                        _mapController.complete(controller);
                      }
                    },
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  if (_isLoadingLocation)
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  if (_errorMessage != null)
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: _getCurrentLocation,
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff113289),
                      mini: true,
                      elevation: 4.0,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Text('Status: '),
                ),
                SizedBox(width: 12),
                Text(
                  capitalize(_status),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Text('Alamat:'),
                ),
                SizedBox(width: 12),
                Flexible(child: Text(_currentAddress)),
              ],
            ),
            SizedBox(height: 20),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 33, right: 33, bottom: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'EEEE',
                              'id_ID',
                            ).format(_attendanceDate ?? DateTime.now()),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'dd MMM yy',
                              'id_ID',
                            ).format(_attendanceDate ?? DateTime.now()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Masuk'),
                              SizedBox(height: 4),
                              Text(_checkInTime),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Pulang'),
                              SizedBox(height: 4),
                              Text(_checkOutTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Divider(),
            SizedBox(height: 10),
            StyledActionButton(
              title: 'Pengajuan Izin',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IzinPage()),
                );
              },
            ),
            SizedBox(height: 10),
            _buildActionButton(),
            SizedBox(height: 15),
            CopyrightWatermark(),
          ],
        ),
      ),
    );
  }

  Center _buildActionButton() {
    bool canCheckIn = !_hasCheckedIn;
    bool canCheckOut = _hasCheckedIn && !_hasCheckedOut;
    String buttonText = "Masuk";
    VoidCallback? onPressed = canCheckIn ? _handleCheckIn : null;

    if (canCheckOut) {
      buttonText = "Pulang";
      onPressed = _handleCheckOut;
    } else if (_hasCheckedIn && _hasCheckedOut) {
      buttonText = "Selesai";
      onPressed = null;
    }

    return Center(
      child: SizedBox(
        height: 45,
        width: 340,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff113289),
            // Disable button when submitting or when the action is not allowed
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
            ),
          ),
          child: _isSubmitting
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(buttonText, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

String capitalize(String s) =>
    s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
