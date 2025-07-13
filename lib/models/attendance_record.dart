import 'package:intl/intl.dart';

class AttendanceRecord {
  final String day;
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final String status;
  final String? alasanIzin;

  AttendanceRecord({
    required this.day,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
    this.alasanIzin,
  });

  bool get isLate {
    if (status != 'masuk' || checkInTime == '-') return false;
    try {
      final timeParts = checkInTime.split(':');
      final hour = int.parse(timeParts[0]);
      return hour >= 8;
    } catch (e) {
      return false;
    }
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // Helper untuk mem-parsing tanggal dari API.
    // API mengirim "2025-07-09 04:12:29", kita anggap ini sebagai UTC.
    DateTime? parseUtcDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        // Ganti spasi dengan 'T' dan tambahkan 'Z' untuk menandakan UTC
        return DateTime.parse("${dateStr.replaceFirst(' ', 'T')}Z");
      } catch (e) {
        // Coba format lain jika perlu, atau kembalikan null jika gagal
        return null;
      }
    }

    final checkInDate = parseUtcDate(json['check_in']);
    final checkOutDate = parseUtcDate(json['check_out']);
    final attendanceDate = json['attendance_date'] != null
        ? DateTime.parse(json['attendance_date'])
        : checkInDate;

    return AttendanceRecord(
      day: attendanceDate != null
          ? DateFormat('EEEE', 'id_ID').format(attendanceDate.toLocal())
          : 'Unknown',
      date: attendanceDate != null
          ? DateFormat('dd MMM yy', 'id_ID').format(attendanceDate.toLocal())
          : 'N/A',
      checkInTime:
          json['check_in_time'] ??
          (checkInDate != null
              ? DateFormat('HH:mm').format(checkInDate.toLocal())
              : '-'),
      checkOutTime:
          json['check_out_time'] ??
          (checkOutDate != null
              ? DateFormat('HH:mm').format(checkOutDate.toLocal())
              : '-'),
      status: json['status'] ?? 'masuk',
      alasanIzin: json['alasan_izin'],
    );
  }
}
