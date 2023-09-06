import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/utils/constants/routingConstants.dart';

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
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(RoutingConstants.loginName);
                          },
                          child: Constants.loginText),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: Constants.welcomeButtonStyle,
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(RoutingConstants.signUpName);
                          },
                          child: Constants.signupText),
                      Constants.or,
                      TextButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(RoutingConstants.homeName);
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
