class ApiEndpoints {
  static final String baseUrl = "https://appabsensi.mobileprojp.com/api";
  static final String storageBaseUrl =
      'https://appabsensi.mobileprojp.com/public';

  // Endpoint Otentikasi
  static final String register = '$baseUrl/register';
  static final String login = '$baseUrl/login';
  static final String logout = '$baseUrl/logout';
  static final String forgotPassword = '$baseUrl/forgot-password';
  static final String resetPassword = '$baseUrl/reset-password';

  // Endpoint Profil
  static final String profile = '$baseUrl/profile';
  static final String updateProfilePhoto = '$baseUrl/profile/photo';

  // Endpoint Data Master
  static final String trainings = '$baseUrl/trainings';
  static final String batches = '$baseUrl/batches';

  // Endpoint Absensi & Izin
  static final String checkIn = '$baseUrl/absen/check-in';
  static final String checkOut = '$baseUrl/absen/check-out';
  static final String submitIzin = '$baseUrl/izin';
  static final String todayAttendance = '$baseUrl/absen/today';
  static final String attendanceHistory = '$baseUrl/absen/history';
  static final String attendanceStats = '$baseUrl/absen/stats';
}
