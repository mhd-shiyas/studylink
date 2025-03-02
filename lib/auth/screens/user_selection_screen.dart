import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studylink/auth/screens/login_screen.dart';
import 'package:studylink/auth/widgets/custom_button.dart';
import 'package:studylink/teacher/screens/login_screen.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Select User Type')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 300,
                  width: 300,
                  child: SvgPicture.asset(
                    "assets/images/user_selection.svg",
                  )),
              SizedBox(
                height: 16,
              ),
              Text(
                "Who Are You?",
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Choose Your Role to Continue",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  title: 'Login as Student',
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherLoginScreen(),
                      ),
                    );
                  },
                  title: 'Login as Teacher',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
