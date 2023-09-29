import 'package:flutter/material.dart';
import 'package:music_player/features/login/widgets/login_textfield.dart';
import 'package:music_player/features/user/widgets/alertdialogue.dart';
import 'package:music_player/features/welcome/ui/welcome.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    TextEditingController unameController = TextEditingController();
    unameController.text = authenticationController.uName!;
    return Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome to PulsePlay,",
                      style: TextStyle(
                        fontSize: 30,
                        color: Constants.white,
                      )),
                  Text(
                    '${authenticationController.uName!}',
                    style: TextStyle(
                        fontSize: 40,
                        color: Constants.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Image.asset('assets/images/logo.png'),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(200, 40)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => UserAlertDialogue(
                              title: 'Change Username',
                              content: LoginFormField(
                                controller: unameController,
                                hint: 'Username',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  } else if (value.length < 4) {
                                    return 'Username must be at least 4 characters long';
                                  }
                                  return null;
                                },
                              ),
                              function: () {
                                authenticationController
                                    .updateUserName(unameController.text);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Edit User Name",
                          style: Constants.loginTextStyle,
                        )),
                    ElevatedButton(
                        style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(200, 40)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => UserAlertDialogue(
                              title: 'Log Out',
                              content: const Text('Are you sure to log out?'),
                              function: () {
                                authenticationController.logout(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen()));
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Log Out",
                          style: TextStyle(color: Constants.red),
                        )),
                    ElevatedButton(
                        style: Constants.welcomeButtonStyle,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => UserAlertDialogue(
                              title: 'Delete Account',
                              content: const Text(
                                  'Do you want to delete the current account?'),
                              function: () {
                                authenticationController.delete(context);
                              },
                            ),
                          );
                        },
                        child: Text("Delete Account",
                            style: Constants.loginTextStyle))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
