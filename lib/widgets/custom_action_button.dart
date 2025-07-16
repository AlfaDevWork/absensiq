import 'package:flutter/material.dart';

class StyledActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const StyledActionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 45,
        width: 340,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff113289),
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
            ),
          ),
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
