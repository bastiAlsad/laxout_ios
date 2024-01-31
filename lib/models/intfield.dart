import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyIntField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final String text;
  final bool obscureText;
  const MyIntField({
    Key? key,
    required this.controller,
    required this.text,
    required this.obscureText,
    required this.fontSize,
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
        hintStyle: const TextStyle(color: Colors.black),
        border: InputBorder.none,
      ),
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black, fontFamily: "Laxout", fontSize: fontSize),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }
}
