import 'package:flutter/material.dart';

class LoginFormField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  bool? pass;

  LoginFormField({super.key, required this.controller,required this.hint,this.pass});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: pass??false,
        decoration: InputDecoration(
          hintText: hint,
          labelStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
