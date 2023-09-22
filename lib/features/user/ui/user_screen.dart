// import 'package:flutter/material.dart';
// import 'package:music_player/features/welcome/ui/welcome.dart';
// import 'package:provider/provider.dart';

// import '../../../controller/authentication_controller.dart';
// import '../../../utils/constants/constants.dart';

// class UserScreen extends StatelessWidget {
//   const UserScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationController authenticationController =
//         Provider.of<AuthenticationController>(context);
//     return Container(
//         decoration: BoxDecoration(gradient: Constants.linearGradient),
//         width: MediaQuery.sizeOf(context).width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//               child: TextButton(onPressed: () {}, child: Text("Edit Username")),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   authenticationController.logout();
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const WelcomeScreen()));
//                 },
//                 child: Text("Log Out"))
//           ],
//         ));
//   }
// }
