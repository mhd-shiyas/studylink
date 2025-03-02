// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';


// import '../constants/color_constants.dart';
// import '../controllers/auth_controller.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => navigatetonNextScreen(context));
//   }

//   navigatetonNextScreen(context) async {
//     final authProvider =
//         Provider.of<AuthenticationProvider>(context, listen: false);
//     await Future.delayed(const Duration(seconds: 1), () {});
//     authProvider.isSignedIn == true
//         ? Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => TeacherHomeScreen()))
//         : Navigator.push(
//             context, MaterialPageRoute(builder: (context) => LoginScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           "StudyLink Teacher",
//           style: GoogleFonts.poppins(
//             color: ColorConstants.primaryColor,
//             fontSize: 22,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//     );
//   }
// }
