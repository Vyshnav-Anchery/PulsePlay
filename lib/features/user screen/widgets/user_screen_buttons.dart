import 'package:flutter/material.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/sharedpref/prefvariable.dart';
import '../../user_authentication/widgets/login_textfield.dart';
import '../../welcome/ui/welcome.dart';
import 'alertdialogue.dart';

class UserActionButtons extends StatelessWidget {
  const UserActionButtons({
    super.key,
    required this.unameController,
    required this.authenticationController,
  });

  final TextEditingController unameController;
  final AuthenticationController authenticationController;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      pass: false,
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
                      AuthenticationController.isLoggedIn == true
                          ? authenticationController
                              .updateUserName(unameController.text)
                          : prefs.setString('username', unameController.text);

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
                    title: AuthenticationController.isLoggedIn == true
                        ? "Log Out"
                        : 'Sign In',
                    content: AuthenticationController.isLoggedIn == true
                        ? const Text('Are you sure to log out?')
                        : const Text('Go to sign in page?'),
                    function: () {
                      Navigator.pop(context);
                      if (AuthenticationController.isLoggedIn == true) {
                        authenticationController.logout(context);
                      }
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()));
                    },
                  ),
                );
              },
              child: Text(
                AuthenticationController.isLoggedIn == true
                    ? "Log Out"
                    : 'Sign In',
                style: TextStyle(color: Constants.red),
              )),
          AuthenticationController.isLoggedIn == true
              ? ElevatedButton(
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
                  child:
                      Text("Delete Account", style: Constants.loginTextStyle))
              : Container()
        ],
      ),
    );
  }
}
