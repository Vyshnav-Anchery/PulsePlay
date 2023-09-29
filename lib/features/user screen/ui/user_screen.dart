import 'package:flutter/material.dart';
import 'package:music_player/features/user_authentication/widgets/login_textfield.dart';
import 'package:music_player/features/user%20screen/widgets/alertdialogue.dart';
import 'package:music_player/features/welcome/ui/welcome.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';
import '../widgets/user_screen_buttons.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    late String uname;
    if (AuthenticationController.isLoggedIn == true) {
      uname = authenticationController.uName!;
    } else {
      uname = prefs.getString('username') ?? '';
    }
    TextEditingController unameController = TextEditingController();
    unameController.text = uname;
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
                    uname,
                    style: TextStyle(
                        fontSize: 40,
                        color: Constants.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Image.asset('assets/images/logo.png'),
              UserActionButtons(
                  unameController: unameController,
                  authenticationController: authenticationController)
            ],
          ),
        ));
  }
}
