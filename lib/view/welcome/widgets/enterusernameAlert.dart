// import 'package:flutter/material.dart';
// import 'package:music_player/utils/constants/constants.dart';

// import '../../../utils/sharedpref/prefvariable.dart';
// import '../../home/ui/home.dart';
// import '../../user screen/widgets/alertdialogue.dart';

// enterUserName(BuildContext context, TextEditingController uNameController) {
//   showDialog(
//     context: context,
//     builder: (context) => UserAlertDialogue(
//       title: 'Enter Username',
//       content: TextFormField(
//         controller: uNameController,
//         decoration: const InputDecoration(hintText: 'Enter Username'),
//       ),
//       function: () {
//         prefs.setString(Constants.USERNAMEKEY, uNameController.text);
//         Navigator.pop(context);
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomeScreen(),
//             ));
//       },
//     ),
//   );
// }
