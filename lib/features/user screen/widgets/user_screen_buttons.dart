import 'package:flutter/material.dart';
import 'package:music_player/features/user%20screen/widgets/image_selector.dart';
import 'package:music_player/features/user_authentication/ui/login.dart';
import 'package:provider/provider.dart';
import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../user_authentication/widgets/login_textfield.dart';
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
    final TextEditingController passwordController = TextEditingController();
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(200, 40)),
              ),
              onPressed: () => showBottomSheet(
                  context: context,
                  builder: (context) => ImageSelectorBottomSheet(
                      authenticationController: authenticationController),
                ),
              child: Text(
                "Change User Image",
                style: Constants.loginTextStyle,
              )),
          ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(200, 40)),
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => UserAlertDialogue(
                    title: 'Change Image',
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
                      authenticationController
                          .updateUserName(unameController.text);

                      Navigator.pop(context);
                    },
                  ),
                ),
              child: Text(
                "Edit User Name",
                style: Constants.loginTextStyle,
              )),
          ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(200, 40)),
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => UserAlertDialogue(
                    title: "Log Out",
                    content: const Text('Are you sure to log out?'),
                    function: () {
                      Navigator.pop(context);
                      authenticationController.logout(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  ),
                ),
              child: Text(
                "Log Out",
                style: TextStyle(color: Constants.red),
              )),
          ElevatedButton(
              style: Constants.welcomeButtonStyle,
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => UserAlertDialogue(
                    title: 'Delete Account',
                    content: const Text(
                        'Do you want to delete the current account?'),
                    function: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => UserAlertDialogue(
                          title: 'Confirm Password',
                          content: Consumer<AuthenticationController>(
                              builder: (context, provider, child) {
                            return LoginFormField(
                                pass: authenticationController.isPassObscure,
                                suffix: IconButton(
                                    onPressed: () => authenticationController
                                          .togglePasswordVisbility(),
                                    icon: Icon(
                                        authenticationController.isPassObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                controller: passwordController,
                                hint: 'Enter Password');
                          }),
                          function: () => authenticationController.deleteAccount(
                                passwordController.text, context),
                        ),
                      );
                    },
                  ),
                ),
              child: Text("Delete Account", style: Constants.loginTextStyle))
        ],
      ),
    );
  }
}
