import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';

class LoginFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool? pass;
  final String? Function(String?)? validator;

  const LoginFormField(
      {super.key,
      required this.controller,
      required this.hint,
      this.pass,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: pass ?? false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        fillColor: Constants.white,
        filled: true,
        hintText: hint,
        labelStyle: TextStyle(color: Constants.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
