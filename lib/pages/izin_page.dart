import 'package:absensiq/models/attendance_record.dart';
import 'package:absensiq/services/attendance_service.dart';
import 'package:absensiq/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final AttendanceService _attendanceService = AttendanceService();

  List<DateTime?> _selectedDates = [];
  bool _isLoading = false;
  List<AttendanceRecord> _izinHistory = [];

  Future<void> _fetchIzinHistory() async {
    try {
      final history = await _attendanceService.getAttendanceHistory();
      if (mounted) {
        setState(() {
          _izinHistory = history
              .where((record) => record.status.toLowerCase() == 'izin')
              .toList();
        });
      }
    } catch (e) {
      _showSnackbar(e.toString(), isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final pickedDates = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );

    if (pickedDates != null) {
      setState(() {
        _selectedDates = [pickedDates];
      });
    }
  }

  Future<void> _handleSubmitIzin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDates.isEmpty) {
      _showSnackbar('Tanggal izin harus dipilih!', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      int successCount = 0;
      for (var date in _selectedDates) {
        if (date != null) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          await _attendanceService.submitIzin(
            alasan: _reasonController.text,
            date: formattedDate,
          );
          successCount++;
        }
      }
      _showSnackbar('$successCount hari izin berhasil diajukan!');
      _formKey.currentState?.reset();
      _reasonController.clear();
      setState(() {
        _selectedDates = [];
      });
      _fetchIzinHistory();
    } catch (e) {
      _showSnackbar(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchIzinHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Pengajuan Izin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _fetchIzinHistory,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Pilih tanggal dan berikan alasan \nketidakhadiran Anda.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 32),
                    InkWell(
                      onTap: _pickDateRange,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Izin',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(4, 4),
                            ),
                          ),
                        ),
                        child: Text(
                          _selectedDates.isEmpty
                              ? 'Pilih Tanggal'
                              : _selectedDates
                                    .map(
                                      (d) => DateFormat('dd/MM/yy').format(d!),
                                    )
                                    .join(', '),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: 'Alasan Izin',
                        hintText: 'Contoh: Sakit, acara keluarga, dll.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(4, 4),
                          ),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      maxLines: 4,
                      validator: (v) =>
                          v!.isEmpty ? 'Alasan tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 32),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Kirim Pengajuan',
                            onPressed: _handleSubmitIzin,
                          ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
