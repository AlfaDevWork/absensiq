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
    DateTime? parseUtcDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse("${dateStr.replaceFirst(' ', 'T')}Z");
      } catch (e) {
        try {
          return DateTime.parse(dateStr);
        } catch (e) {
          return null;
        }
      }
    }

    final checkInDate = parseUtcDate(json['check_in']);
    final checkOutDate = parseUtcDate(json['check_out']);

    return AttendanceRecord(
      day: checkInDate != null
          ? DateFormat('EEEE', 'id_ID').format(checkInDate.toLocal())
          : 'Unknown',
      date: checkInDate != null
          ? DateFormat('dd MMM yy', 'id_ID').format(checkInDate.toLocal())
          : 'N/A',
      checkInTime: checkInDate != null
          ? DateFormat('HH:mm:ss').format(checkInDate.toLocal())
          : '-',
      checkOutTime: checkOutDate != null
          ? DateFormat('HH:mm:ss').format(checkOutDate.toLocal())
          : '-',
    );
  }
}
