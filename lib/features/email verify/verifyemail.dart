// import 'dart:async';
// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:music_player/controller/authentication_controller.dart';
// import 'package:music_player/features/home/ui/home.dart';
// import 'package:music_player/features/welcome/ui/welcome.dart';
// import 'package:music_player/utils/constants/constants.dart';
// import 'package:provider/provider.dart';

// class EmailVerifyPage extends StatefulWidget {
//   const EmailVerifyPage({super.key});

//   @override
//   State<EmailVerifyPage> createState() => _EmailVerifyPageState();
// }

// class _EmailVerifyPageState extends State<EmailVerifyPage> {
//   late AuthenticationController authenticationController =
//       Provider.of<AuthenticationController>(context, listen: false);
//   Timer? timer;
//   Stream<bool>? emailVerifiedStream; // Stream to check email verification

//   @override
//   void initState() {
//     emailVerifiedStream = Stream.periodic(
//       const Duration(seconds: 3), // Check every 3 seconds
//       (_) => authenticationController.isEmailVerified,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<bool>(
//       stream: emailVerifiedStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final isEmailVerified = snapshot.data ?? false;
//           if (isEmailVerified) {
//             // Email is verified, navigate to HomeScreen
//             Navigator.pushReplacement(context, );
//           } else {
//             // Email is not verified, display the verification UI
//             return Scaffold(
//               backgroundColor: Constants.appBg,
//               appBar: AppBar(),
//               body: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "A verification email has been sent to your email",
//                       style: Constants.musicListTextStyle,
//                     ),
//                     const SizedBox(height: 20),
//                     TextButton(
//                       onPressed: () {
//                         authenticationController.sendVerificationMail();
//                       },
//                       child: const Text("Resend Email"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         FirebaseAuth.instance
//                             .signOut()
//                             .then((value) => Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const WelcomeScreen(),
//                                   ),
//                                 ));
//                       },
//                       child: const Text("Cancel"),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         } else {
//           // Connection state is not active, display loading or handle accordingly
//           return CircularProgressIndicator(); // You can replace this with a loading indicator
//         }
//       },
//     );
//   }
// }
