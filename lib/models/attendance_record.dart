import 'package:intl/intl.dart';

class AttendanceRecord {
  final String day;
  final String date;
  final String checkInTime;
  final String checkOutTime;

  AttendanceRecord({
    required this.day,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    DateTime? attendanceDate;
    if (json['attendance_date'] != null) {
      try {
        // Membuat objek DateTime dari tanggal yang diberikan
        attendanceDate = DateTime.parse(json['attendance_date']);
      } catch (e) {
        // Biarkan null jika format tanggal tidak valid
      }
    }

    return AttendanceRecord(
      day: attendanceDate != null
          ? DateFormat('EEEE', 'id_ID').format(attendanceDate)
          : 'Unknown',
      date: attendanceDate != null
          ? DateFormat('dd MMM yy', 'id_ID').format(attendanceDate)
          : 'N/A',
      checkInTime: json['check_in_time'] ?? '-',
      checkOutTime: json['check_out_time'] ?? '-',
    );
  }
}
