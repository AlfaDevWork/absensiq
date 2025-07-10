class User {
  final int id;
  final String name;
  final String email;
  final String? profilePhotoUrl;
  final String? trainingTitle;
  final String? batchKe;
  final String? jenisKelamin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    this.trainingTitle,
    this.batchKe,
    this.jenisKelamin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userData = json['user'] ?? json['data'] ?? {};

    // Hanya mengambil URL lengkap jika tersedia dari API
    String? finalPhotoUrl =
        json['profile_photo_url'] ?? userData['profile_photo_url'];

    return User(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'No Name',
      email: userData['email'] ?? 'No Email',
      profilePhotoUrl: finalPhotoUrl,
      trainingTitle:
          userData['training_title'] ?? userData['training']?['title'],
      batchKe: userData['batch_ke'] ?? userData['batch']?['batch_ke'],
      jenisKelamin: userData['jenis_kelamin'],
    );
  }
}
