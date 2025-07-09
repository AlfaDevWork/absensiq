import 'package:absensiq/constant/app_color.dart';
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: Column(
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
            SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Text('Status: '),
                ),
                SizedBox(width: 12),
                Text('data', style: TextStyle(fontWeight: FontWeight.bold)),
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
                Flexible(
                  child: Text(
                    'Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatra Utara',
                  ),
                ),
              ],
            ),
            SizedBox(height: 36),
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
                          Text('Monday'),
                          SizedBox(height: 4),
                          Text('13-Jun-25'),
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
                              Text('Check In'),
                              SizedBox(height: 4),
                              Text('Jam'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Check Out'),
                              SizedBox(height: 4),
                              Text('Jam'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 45,
                width: 340,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff84BFFF),
                  ),
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                  label: Text(
                    'Ambil Foto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                height: 45,
                width: 340,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff113289),
                  ),
                  child: Text(
                    'Check In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
