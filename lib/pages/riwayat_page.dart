import 'package:absensiq/models/attendance_record.dart';
import 'package:absensiq/models/attendance_stats.dart';
import 'package:absensiq/services/attendance_service.dart';
import 'package:absensiq/widgets/attendance_history_card.dart';
import 'package:absensiq/widgets/izin_history_card.dart';
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
        _attendanceService.getAttendanceHistory(),
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
        backgroundColor: Colors.transparent,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                  children: [
                    _StatCard(
                      title: 'Hadir',
                      value: _stats?.totalMasuk.toString() ?? '0',
                      color: Color(0xff113289),
                    ),
                    _StatCard(
                      title: 'Izin',
                      value: _stats?.totalIzin.toString() ?? '0',
                      color: Color(0xff113289),
                    ),
                  ],
                ),
              ),
              Divider(indent: 27, endIndent: 27),
              SizedBox(height: 10),
              _history.isEmpty
                  ? Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 24),
                      child: Center(child: Text('Belum ada riwayat kehadiran')),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _history.length,
                      itemBuilder: (BuildContext context, int index) {
                        final record = _history[index];
                        if (record.status.toLowerCase() == 'izin') {
                          return IzinHistoryCard(record: record);
                        } else {
                          return AttendanceHistoryCard(record: record);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _StatCard({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
