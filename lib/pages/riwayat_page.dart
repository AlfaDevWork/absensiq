import 'package:absensiq/models/attendance_record.dart';
import 'package:absensiq/models/attendance_stats.dart';
import 'package:absensiq/services/attendance_service.dart';
import 'package:absensiq/widgets/attendance_history_card.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});
  static const String id = "/riwayat";

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceRecord> _history = [];
  AttendanceStats? _stats;
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _attendanceService.getAttendanceStats(),
        _attendanceService.getAttendanceHistory(limit: 100),
      ]);

      if (mounted) {
        setState(() {
          _stats = results[0] as AttendanceStats;
          _history = results[1] as List<AttendanceRecord>;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text('Riwayat Kehadiran'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (BuildContext context, int index) =>
                    AttendanceHistoryCard(record: _history[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
