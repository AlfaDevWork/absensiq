import 'package:flutter/material.dart';

class CopyrightWatermark extends StatelessWidget {
  const CopyrightWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Text(
          '© 2024 Alfarezhi M.R . All rights reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
