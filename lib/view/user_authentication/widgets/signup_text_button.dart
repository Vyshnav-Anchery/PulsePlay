import 'package:flutter/material.dart';

import '../../../utils/constants/constants.dart';
import '../ui/signup.dart';

class SignUpTextButton extends StatelessWidget {
  const SignUpTextButton({
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
                  EdgeInsets.zero),
              backgroundColor:
                  MaterialStateProperty.all<Color?>(Colors.transparent),
              overlayColor:
                  MaterialStateProperty.all<Color?>(Colors.transparent),
              alignment: Alignment.centerLeft,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              )),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
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
