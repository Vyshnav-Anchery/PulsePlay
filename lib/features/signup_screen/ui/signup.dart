import 'package:flutter/material.dart';

import '../../../utils/constants/constants.dart';
import '../../login/widgets/login_textfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController = TextEditingController();
  final TextEditingController unameSignUpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBg,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 90,
              child: Image.asset(
                Constants.logo,
                fit: BoxFit.contain,
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: Constants.cardBg,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Constants.signUpHeading,
                    const SizedBox(height: 30),
                    LoginFormField(controller: unameSignUpController, hint: "User Name"),
                    const SizedBox(height: 10),
                    LoginFormField(controller: emailSignUpController, hint: "Email"),
                    const SizedBox(height: 10),
                    LoginFormField(
                      controller: passwordSignUpController,
                      hint: "Password",
                      pass: true,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: Constants.welcomeButtonStyle,
                        onPressed: () {},
                        child: Constants.signupText),
                    Constants.or,
                    TextButton(onPressed: () {}, child: Constants.withoutLogin),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
