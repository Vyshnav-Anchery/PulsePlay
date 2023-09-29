import 'package:flutter/material.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/features/login/ui/login.dart';
import 'package:music_player/features/signup_screen/ui/signup.dart';
import '../../../utils/constants/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                color: Constants.cardBg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Constants.welcomeText,
                      const SizedBox(height: 30),
                      ElevatedButton(
                          style: Constants.welcomeButtonStyle,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              )),
                          child: Constants.loginText),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: Constants.welcomeButtonStyle,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ));
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
              )
            ],
          ),
        ));
  }
}
