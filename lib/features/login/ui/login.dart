import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/features/login/widgets/login_textfield.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/constants/routingConstants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    Constants.loginHeading,
                    const SizedBox(height: 30),
                    LoginFormField(controller: emailController,hint: "Email"),
                    SizedBox(height: 10),
                    LoginFormField(controller: passwordController,hint: "Password",pass: true,),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: Constants.welcomeButtonStyle,
                        onPressed: () {},
                        child: Constants.loginText),
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
