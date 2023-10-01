import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';

class LoginFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool? pass;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const LoginFormField(
      {super.key,
      required this.controller,
      required this.hint,
      this.pass,
      this.validator,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {},

      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      obscureText: pass ?? false,
      decoration: InputDecoration(
        errorMaxLines: 2,
        
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          fillColor: Constants.white,
          filled: true,
          hintText: hint,
          labelStyle: TextStyle(color: Constants.red),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: (pass != null) ? suffix : Container()),
    );
  }
}
