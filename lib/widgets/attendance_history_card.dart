// lib/widgets/attendance_history_card.dart

import 'package:absensiq/constant/app_color.dart';
import 'package:absensiq/models/attendance_record.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryCard extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceHistoryCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26, bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.day,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Data dari objek record
                  const SizedBox(height: 4),
                  Text(record.date), // Data dari objek record
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Masuk',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(record.checkInTime), // Data dari objek record
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Pulang',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(record.checkOutTime), // Data dari objek record
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
