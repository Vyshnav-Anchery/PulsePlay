import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';
import '../widgets/user_image.dart';
import '../widgets/user_screen_buttons.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);

    TextEditingController unameController = TextEditingController();
    return Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
              future: authenticationController.getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please wait..",
                        style: Constants.musicListTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error getting username"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: Text('Username not available',
                          style: Constants.musicListTextStyle));
                } else {
                  String? uname = authenticationController.uName ?? "User";
                  unameController.text = uname;
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Welcome to PulsePlay,",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       color: Constants.white,
                            //     )),
                            Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(
                                  uname,
                                  style: const TextStyle(fontSize: 30),
                                ),
                                subtitle: Text(
                                  FirebaseAuth.instance.currentUser!.email!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                trailing: const UserImageWidget(),
                              ),
                            ),
                          ],
                        ),
                        UserActionButtons(
                            unameController: unameController,
                            authenticationController: authenticationController)
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}
