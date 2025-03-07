import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/auth/controllers/auth_controller.dart';
import 'package:studylink/auth/screens/forgot_password_screen.dart';
import 'package:studylink/constants/color_constants.dart';
import 'package:studylink/dashboard/home/screens/home_screen.dart';
import 'package:studylink/dashboard/widgets/custom_appbar.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //final AuthController _authController = AuthController();

  void login() {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    authProvider.loginWithEmailPassword(
        email: email,
        password: password,
        context: context,
        onSuccess: () {
          authProvider.setSignIn().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    "assets/icons/login.svg",
                  )),
              Text(
                "Sign In.!",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Enter your email to access your account",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
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
              const SizedBox(height: 12),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    passwordController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Password",
                hint: "Password",
                controller: passwordController,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      )),
                  child: const Text(
                    'Forgot Your Password?',
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: "login",
                  onTap: emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty
                      ? () => login()
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have an Account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen())),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
