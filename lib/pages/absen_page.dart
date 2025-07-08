import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});
  static const String id = "/absen";

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = 'Alamat tidak ditemukan';
  Marker? _marker;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text('Kehadiran'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 320,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: _marker != null ? {_marker!} : {},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          SizedBox(height: 20),
          Text('Status'),
        ],
      ),
    );
  }
}
