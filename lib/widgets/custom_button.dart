import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color; // Parameter opsional untuk warna tombol

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan warna tombol: gunakan warna kustom jika ada, jika tidak, gunakan warna primer
    final buttonColor = color ?? Color(0xff113289);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          // Memberi warna abu-abu saat tombol dinonaktifkan
          disabledBackgroundColor: buttonColor.withOpacity(0.5),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        // onPressed bisa menerima null, yang akan menonaktifkan tombol secara otomatis
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
