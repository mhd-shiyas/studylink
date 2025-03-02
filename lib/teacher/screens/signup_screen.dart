import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/controllers/auth_controller.dart';

import '../constants/color_constants.dart';
import 'complete_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _collegeCodeController = TextEditingController();

  bool _isLoading = false;

  // void signUp() {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();
  //   authProvider.signUpWithEmailPassword(
  //     email: email,
  //     password: password,
  //     context: context,
  //     onSuccess: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CompleteScreen(),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _signup() async {
    final authProvider =
        Provider.of<TeachersAuthenticationProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await authProvider.signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Signup successful! Await admin approval.')),
      // );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteScreen(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "assets/icons/login.svg",
                  )),
              Text(
                "Sign Up.!",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Create a new Account",
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
                    _collegeCodeController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "College Code",
                hint: "College Code",
                controller: _collegeCodeController,
              ),
              const SizedBox(height: 12),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    _emailController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Email",
                hint: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 12),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    _passwordController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Password",
                hint: "Password",
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: "Sign Up",
                        onTap: _emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _collegeCodeController.text == "meskc"
                            ? () => _signup()
                            : null,
                      ),
                    ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Have an Account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherLoginScreen())),
                    child: const Text(
                      'Login.',
                      style: TextStyle(
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // TextField(
              //   controller: _emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
              // ),
              // const SizedBox(height: 16),
              // TextField(
              //   controller: _passwordController,
              //   decoration: const InputDecoration(labelText: 'Password'),
              //   obscureText: true,
              // ),
              // const SizedBox(height: 24),
              // ElevatedButton(
              //   onPressed: () {},
              //   child: const Text('Sign Up'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
