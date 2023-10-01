import 'package:flutter/material.dart';
import 'package:music_player/controller/authentication_controller.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/features/user_authentication/ui/login.dart';
import 'package:music_player/features/user_authentication/ui/signup.dart';
import 'package:music_player/features/welcome/widgets/enterusernameAlert.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/sharedpref/prefvariable.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController uNameController = TextEditingController();
    return Scaffold(
        backgroundColor: Constants.appBg,
        body: Center(
          child: SingleChildScrollView(
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
                        const SizedBox(height: 50)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
