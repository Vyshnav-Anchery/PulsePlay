import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: pass ?? false,
        decoration: InputDecoration(
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
