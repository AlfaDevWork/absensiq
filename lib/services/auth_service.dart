import 'dart:convert';
import 'dart:io';

import 'package:absensiq/api/api_endpoints.dart';
import 'package:absensiq/models/batch.dart';
import 'package:absensiq/models/training.dart';
import 'package:absensiq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<List<Training>> getTrainings() async {
    final url = Uri.parse(ApiEndpoints.trainings);
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Training.fromJson(json)).toList();
      } else {
        throw 'Gagal memuat data pelatihan.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server. Periksa koneksi internet anda';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Batch>> getBatches() async {
    final url = Uri.parse(ApiEndpoints.batches);
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Batch.fromJson(json)).toList();
      } else {
        throw 'Gagal memuat data batch.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server. Periksa koneksi internet anda.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String jenisKelamin,
    required String batchId,
    required String trainingId,
    File? profilePhoto,
  }) async {
    final url = Uri.parse(ApiEndpoints.register);
    try {
      Map<String, String> body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'jenis_kelamin': jenisKelamin,
        'batch_id': batchId,
        'training_id': trainingId,
      };

      if (profilePhoto != null) {
        List<int> imageBytes = await profilePhoto.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        body['profile_photo'] = 'data:image/jpeg;base64,$base64Image';
      }

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else if (response.statusCode == 422 && responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        throw errors.values.first[0];
      } else {
        throw responseData['message'] ?? 'Terjadi kesalahan registrasi.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiEndpoints.login);
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['data']?['token'] != null) {
          await _saveToken(responseData['data']['token']);
        }
        return responseData;
      } else {
        throw responseData['message'] ?? 'Email atau password salah';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final url = Uri.parse(ApiEndpoints.forgotPassword);
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email},
      );
      final responeData = json.decode(response.body);
      if (response.statusCode == 200) {
        return responeData;
      } else {
        throw responeData['message'] ?? 'Gagal mengirim OTP.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final url = Uri.parse(ApiEndpoints.resetPassword);
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': password,
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Gagal mereset password.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User> getUserProfile() async {
    final token = await getToken();
    if (token == null) throw 'Token tidak ditemukan. Silahkan login kembali.';

    final url = Uri.parse(ApiEndpoints.profile);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw 'Gagal mengambil data profil';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    required String email,
    required String jenisKelamin,
  }) async {
    final token = await getToken();
    if (token == null) throw 'Token tidak ditemukan';

    final url = Uri.parse(ApiEndpoints.profile);
    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'jenis_kelamin': jenisKelamin,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else if (response.statusCode == 422 && responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        throw errors.values.first[0];
      } else {
        throw responseData['message'] ?? 'Gagal memperbarui profil.';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> updateProfilePhoto({required File photo}) async {
    final token = await getToken();
    if (token == null) throw 'Token tidak ditemukan';

    final url = Uri.parse(ApiEndpoints.updateProfilePhoto);
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('profile_photo', photo.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Gagal memperbarui foto profil';
      }
    } on SocketException {
      throw 'Tidak dapat terhubung ke server';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token == null) {
      await _removeToken();
      return;
    }

    final url = Uri.parse(ApiEndpoints.logout);
    try {
      await http.post(
        url,
        headers: {
          'Accept': 'Application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } finally {
      await _removeToken();
    }
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
