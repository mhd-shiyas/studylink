import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<TeachersAuthenticationProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    "assets/icons/undraw_forgot-password_odai.svg",
                  )),
              Text(
                "Forgot Password?",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Enter your email. We'll send a link to your email",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    emailController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Email",
                hint: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: "Reset Password",
                  onTap: emailController.text.isNotEmpty
                      ? () {
                          // authProvider.resetPassword(
                          //   context: context,
                          //   email: emailController.text.trim(),
                          // );
                          // Navigator.pop(context);
                        }
                      : null,
                ),
              ),
              // TextField(
              //   controller: emailController,
              //   decoration: const InputDecoration(labelText: "Enter your email"),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     authProvider.resetPassword(
              //       context: context,
              //       email: emailController.text.trim(),
              //     );
              //   },
              //   child: const Text("Reset Password"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
