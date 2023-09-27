import 'package:flutter/material.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/features/signup_screen/widget/verification_alert.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../email verify/verifyemail.dart';
import '../../login/widgets/login_textfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> signupformKey = GlobalKey<FormState>();
  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  final TextEditingController confirmPasswordSignUpController =
      TextEditingController();
  final TextEditingController unameSignUpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    return Scaffold(
      backgroundColor: Constants.appBg,
      body: SingleChildScrollView(
        child: Center(
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                color: Constants.cardBg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: signupformKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Constants.signUpHeading,
                        const SizedBox(height: 30),
                        LoginFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              } else if (value.length < 4) {
                                return 'Username must be at least 4 characters long';
                              }
                              return null;
                            },
                            controller: unameSignUpController,
                            hint: "User Name"),
                        const SizedBox(height: 10),
                        LoginFormField(
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
                            controller: emailSignUpController,
                            hint: "Email"),
                        const SizedBox(height: 10),
                        LoginFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            // Check for minimum length
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            // Check for at least one uppercase letter
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            // Check for at least one lowercase letter
                            if (!value.contains(RegExp(r'[a-z]'))) {
                              return 'Password must contain at least one lowercase letter';
                            }
                            // Check for at least one digit
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Password must contain at least one digit';
                            }
                            // Check for at least one special character (customize the character set)
                            if (!value.contains(
                                RegExp(r'[!@#\$%^&*()_+{}:;<>,.?~]'))) {
                              return 'Password must contain at least one special character';
                            }
                            if (value.contains(' ')) {
                              return 'Password must not contain spaces';
                            }
                            return null;
                          },
                          controller: passwordSignUpController,
                          hint: "Password",
                          pass: false,
                        ),
                        const SizedBox(height: 10),
                        LoginFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            // Check for minimum length
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            if (confirmPasswordSignUpController.text !=
                                passwordSignUpController.text) {
                              return 'Passwords are not same';
                            }
                            return null;
                          },
                          controller: confirmPasswordSignUpController,
                          hint: "Re-Enter password",
                          pass: false,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: Constants.welcomeButtonStyle,
                            onPressed: () {
                              if (signupformKey.currentState!.validate()) {
                                authenticationController.emailSignUp(
                                    emailSignUpController.text,
                                    passwordSignUpController.text,
                                    unameSignUpController.text,
                                    context);
                                showDialog(
                                    context: context,
                                    builder: (context) => VerificationAlert());
                              }
                            },
                            child: Constants.signupText),
                        Constants.or,
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                            },
                            child: Constants.withoutLogin),
                        const SizedBox(height: 50)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
