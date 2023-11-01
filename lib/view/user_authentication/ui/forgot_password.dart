import 'package:flutter/material.dart';
import 'package:music_player/controller/authentication_controller.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:provider/provider.dart';

import '../widgets/login_textfield.dart';

final GlobalKey<FormState> forgotPassFormKey = GlobalKey<FormState>();

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authentiicator =
        Provider.of<AuthenticationController>(context);
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Reset Password",
            style: Constants.musicListTextStyle,
          ),
          backgroundColor: Constants.appBg,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(gradient: Constants.linearGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Receive an email to reset your password",
                    style: Constants.musicListTextStyle,
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: forgotPassFormKey,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      child: LoginFormField(
                          pass: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailController,
                          hint: "Email"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (forgotPassFormKey.currentState!.validate()) {
                          authentiicator.resetPassword(
                              emailController.text.trim(), context);
                        }
                      },
                      child: const Text(
                        "Send mail",
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
