// File: custom_text_form_field.dart

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUnfocus,
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
