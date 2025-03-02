import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/constants/color_constants.dart';
import 'package:studylink/teacher/controllers/auth_controller.dart';

import '../auth/controllers/auth_controller.dart';
import '../auth/screens/user_selection_screen.dart';
import '../teacher/screens/home_screen.dart';
import '../dashboard/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => navigateToNextScreen(context));
  }

  Future<void> navigateToNextScreen(context) async {
    final teacherAuthProvider =
        Provider.of<TeachersAuthenticationProvider>(context, listen: false);
    final studentAuthProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 1));

    if (teacherAuthProvider.isSignedIn) {
      // Redirect to Teacher Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherHomeScreen()),
      );
    } else if (studentAuthProvider.isSignedIn) {
      // Redirect to Student Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // No user is logged in, go to selection screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "StudyLink",
          style: GoogleFonts.poppins(
            color: ColorConstants.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
