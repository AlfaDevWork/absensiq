// Pastikan Anda memiliki definisi untuk AppColor.border
// Jika tidak, Anda bisa menggantinya dengan warna lain, contoh: Colors.grey.shade300
import 'package:absensiq/constant/app_color.dart';
import 'package:absensiq/models/attendance_record.dart';
import 'package:flutter/material.dart';

class IzinHistoryCard extends StatelessWidget {
  final AttendanceRecord record;

  const IzinHistoryCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Menggunakan padding seperti pada kartu referensi
      padding: const EdgeInsets.only(left: 26, right: 26, bottom: 15),
      child: Container(
        // Menyesuaikan padding internal dan dekorasi container
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.border,
          ), // Menggunakan border, bukan shadow
        ),
        child: Row(
          children: [
            // Kolom untuk Hari dan Tanggal (flex: 2)
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.day},', // Menggabungkan hari dan tanggal
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.date,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Kolom untuk Keterangan Izin (flex: 3)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keterangan Izin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (record.alasanIzin != null &&
                            record.alasanIzin!.isNotEmpty)
                          Text(
                            record.alasanIzin!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Ikon status di ujung kanan
                  const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
