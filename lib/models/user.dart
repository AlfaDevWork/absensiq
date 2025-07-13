import 'package:absensiq/api/api_endpoints.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? profilePhotoUrl;
  final String? trainingTitle;
  final String? batchKe;
  final String? jenisKelamin;
  final String? batchId;
  final String? trainingId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    this.trainingTitle,
    this.batchKe,
    this.jenisKelamin,
    this.batchId,
    this.trainingId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userData = json['user'] ?? json['data'] ?? {};

    String? finalPhotoUrl;

    if (json['profile_photo_url'] != null) {
      finalPhotoUrl = json['profile_photo_url'];
    } else if (userData['profile_photo'] != null) {
      finalPhotoUrl =
          '${ApiEndpoints.storageBaseUrl}/${userData['profile_photo']}';
    }

    return User(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'No Name',
      email: userData['email'] ?? 'No Email',
      profilePhotoUrl: finalPhotoUrl,
      trainingTitle:
          userData['training_title'] ?? userData['training']?['title'],
      batchKe: userData['batch_ke'] ?? userData['batch']?['batch_ke'],
      jenisKelamin: userData['jenis_kelamin'],
      batchId: userData['batch_id']?.toString(),
      trainingId: userData['training_id']?.toString(),
    );
  }
}
