import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final String text;
  final bool obscureText;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.text,
    required this.obscureText, required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: false,
        hintText: text,
        
        hintStyle: const TextStyle(color: Colors.black,),
        border: InputBorder.none, // Dieser Code entfernt den unteren Strich
      ),
      cursorColor: Colors.black, // Farbe des Cursors
      style: TextStyle(color: Colors.black, fontFamily: "Laxout",fontSize: fontSize),
    );
  }
}
