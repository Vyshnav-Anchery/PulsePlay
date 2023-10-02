import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/features/user_authentication/ui/login.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';

class VerificationAlert extends StatelessWidget {
  const VerificationAlert({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    return AlertDialog(
      title: const Text('Mail sent'),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).width * (1 / 4.9),
        child: Column(
          children: [
            const Text(
                "A verification Mail has been sent to your email.Verify to Continue"),
            Row(
              children: [
                const Text("Didn't receive mail ? "),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero), // Remove padding
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color?>(Colors
                            .transparent), // Remove overlay color on press
                        alignment:
                            Alignment.centerLeft, // Align text to the left
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Remove extra tap target size
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                          color: Colors
                              .red, // Set the text color to blue or your desired link color
                          decoration: TextDecoration
                              .underline, // Add underline decoration to mimic a link
                        ))),
                    onPressed: () =>
                        authenticationController.sendVerificationMail(),
                    child: const Text("send again")),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .delete();
              FirebaseAuth.instance.currentUser!
                  .delete()
                  .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ));
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (authenticationController.checkEmailVerified()) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
              }
            },
            child: const Text('Continue')),
      ],
    );
  }
}
