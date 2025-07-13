import 'dart:convert';
import 'dart:io';

import 'package:absensiq/api/api_endpoints.dart';
import 'package:absensiq/models/attendance_record.dart';
import 'package:absensiq/services/auth_service.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  final AuthService _authService = AuthService();

  Future<String> _getAuthToken() async {
    final token = await _authService.getToken();
    if (token == null) throw 'Sesi anda telah berakhir. Silakan login kembali';
    return token;
  }

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    required String address,
    required String date,
    required String time,
  }) async {
    final token = await _getAuthToken();
    final url = Uri.parse(ApiEndpoints.checkIn);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'check_in_lat': latitude.toString(),
          'check_in_lng': longitude.toString(),
          'check_in_address': address,
          'attendance_date': date,
          'check_in': time,
          'status': 'masuk',
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Gagal melakukan check-in.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      print('Error in checkIn: $e');
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    required String address,
    required String date,
    required String time,
  }) async {
    final token = await _getAuthToken();
    final url = Uri.parse(ApiEndpoints.checkOut);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'check_out_lat': latitude.toString(),
          'check_out_lng': longitude.toString(),
          'check_out_address': address,
          'attendance_date': date,
          'check_out': time,
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Gagal melakukan check-out.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      print('Error in checkOut: $e');
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> submitIzin({required String alasan}) async {
    final token = await _getAuthToken();
    final url = Uri.parse(ApiEndpoints.submitIzin);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'alasan_izin': alasan},
      );
      return json.decode(response.body);
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> getTodayAttendance() async {
    final token = await _getAuthToken();
    final url = Uri.parse(ApiEndpoints.todayAttendance);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<AttendanceRecord>> getAttendanceHistory({int limit = 10}) async {
    final token = await _getAuthToken();
    final url = Uri.parse('${ApiEndpoints.attendanceHistory}?limit=$limit');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => AttendanceRecord.fromJson(json)).toList();
      } else {
        throw 'Gagal memuat riwayat absensi.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }
}
