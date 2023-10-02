import 'package:flutter/material.dart';

import '../../../utils/constants/constants.dart';
import '../ui/signup.dart';

class SIgnUpTextButton extends StatelessWidget {
  const SIgnUpTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Dont have an account ? ", style: Constants.musicListTextStyle),
        TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.zero), // Remove padding
              backgroundColor:
                  MaterialStateProperty.all<Color?>(Colors.transparent),
              overlayColor: MaterialStateProperty.all<Color?>(
                  Colors.transparent), // Remove overlay color on press
              alignment: Alignment.centerLeft, // Align text to the left
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Remove extra tap target size
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                color: Colors
                    .red, // Set the text color to blue or your desired link color
                decoration: TextDecoration
                    .underline, // Add underline decoration to mimic a link
              )),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ));
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.red,
                // decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }
}
