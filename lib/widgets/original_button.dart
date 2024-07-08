// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

class OriginalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color bgColor;

  const OriginalButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.textColor,
      required this.bgColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // primary: bgColor, // Background color
            // onPrimary: textColor, // Text Color (Foreground color)
            foregroundColor: textColor,
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(text, style: TextStyle(fontSize: 18))),
    );
  }
}
