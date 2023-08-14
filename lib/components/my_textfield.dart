// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final bool isEditable;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.inputType,
      required this.isEditable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: Colors.grey.shade700),
        controller: controller,
        decoration: InputDecoration(
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          enabled: isEditable,
        ),
        obscureText: obscureText,
        keyboardType: inputType,
      ),
    );
  }
}
