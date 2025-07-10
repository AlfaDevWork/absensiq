class ApiEndpoints {
  static final String baseUrl = "https://appabsensi.mobileprojp.com/api";

  // Endpoint untuk Otentikasi
  static final String register = '$baseUrl/register';
  static final String login = '$baseUrl/login';
  static final String logout = '$baseUrl/logout';
  static final String forgotPassword = '$baseUrl/forgot-password';
  static final String resetPassword = '$baseUrl/reset-password';

  // Endpoint untuk Profil
  static final String profile = '$baseUrl/profile';
  static final String updateProfilePhoto = '$baseUrl/profile/photo';

  // Endpoint untuk Data Master
  static final String trainings = '$baseUrl/trainings';
  static final String batches = '$baseUrl/batches';

  // Endpoint untuk Absensi & Izin
  static final String checkIn = '$baseUrl/absen/check-in';
  static final String checkOut = '$baseUrl/absen/check-out';
  static final String submitIzin = '$baseUrl/absen/izin';
  static final String todayAttendance = '$baseUrl/absen/today';
  static final String attendanceHistory = '$baseUrl/absen/history';
}
