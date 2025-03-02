import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/color_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  //final AuthController _authController = AuthController();

  // void login() {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   authProvider.loginWithEmailPassword(
  //     email: email,
  //     password: password,
  //     context: context,
  //     onSuccess: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomeScreen(),
  //       ),
  //     ),
  //   );
  // }

  void _login() async {
    final authProvider =
        Provider.of<TeachersAuthenticationProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await authProvider.loginWithEmailPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
          onSuccess: () {
            authProvider.setSignIn().then((value) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherHomeScreen(),
                  ));
            });
          });
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
                "Enter your email and password to access your account",
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
                // prefix: Container(
                //   padding: const EdgeInsets.all(8).copyWith(top: 14, left: 12),
                //   child: InkWell(
                //     onTap: () {
                //       showCountryPicker(
                //           context: context,
                //           countryListTheme:
                //               const CountryListThemeData(bottomSheetHeight: 400),
                //           onSelect: (val) {
                //             // selecetCountry = val;
                //           });
                //     },
                //     child: Text(
                //       "${selecetCountry.flagEmoji} +${selecetCountry.phoneCode}",
                //       style: GoogleFonts.montserrat(
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                // suffix: emailController.text.isNotEmpty
                //     ? Container(
                //         height: 30,
                //         width: 30,
                //         margin: const EdgeInsets.all(20),
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: Colors.green,
                //         ),
                //         child: const Icon(
                //           Icons.done,
                //           color: Colors.white,
                //           size: 20,
                //         ),
                //       )
                //     : null,
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
                // suffix: passwordController.text.isNotEmpty
                //     ? Container(
                //         height: 30,
                //         width: 30,
                //         margin: const EdgeInsets.all(20),
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: Colors.green,
                //         ),
                //         child: const Icon(
                //           Icons.done,
                //           color: Colors.white,
                //           size: 20,
                //         ),
                //       )
                //     : null,
              ),
              // SizedBox(
              //   height: 4,
              // ),
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
              _isLoading
                  ? const CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: "login",
                        onTap: emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty
                            ? () => _login()
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

              // ElevatedButton(
              //   onPressed:
              //   child: const Text("Send OTP"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:college_project/auth/otp_screen.dart';
// import 'package:college_project/auth/widgets/custom_textfield.dart';
// import 'package:college_project/auth/signup/screens/signup_screen.dart';
// import 'package:flutter/material.dart';

// import '../../controllers/auth_controller.dart';
// import '../../widgets/custom_button.dart';

// class TeacherLoginScreen extends StatefulWidget {
//   const TeacherLoginScreen({super.key});

//   @override
//   State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
// }

// class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
//   final phoneNoController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   sendOTP() async {
//     await AuthController().sendOTP(phoneNoController.text, (String verId) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => OtpScreen()));
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     phoneNoController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 60,
//               ),
//               const Text(
//                 "Login",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),

//               const Text(
//                 "Welcome Back!",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               // Align(
//               //   alignment: Alignment.topLeft,
//               //   child: Container(
//               //     width: 200,
//               //     height: 200,
//               //     decoration: const BoxDecoration(
//               //       gradient: LinearGradient(
//               //         colors: [Colors.blue, Colors.indigo],
//               //         begin: Alignment.topCenter,
//               //         end: Alignment.bottomCenter,
//               //       ),
//               //       borderRadius: BorderRadius.only(
//               //         bottomRight: Radius.circular(50),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(height: 40),
//               // Login card
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Form(
//                     key: _formKey,
//                     child: CustomTextfield(
//                       label: "Phone Number",
//                       hint: "Phone Number",
//                       controller: phoneNoController,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Password field
//                   const CustomTextfield(label: "Password", hint: "Password"),
//                   const SizedBox(height: 4),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         'Forgot Your Password?',
//                         style: TextStyle(
//                           color: Colors.indigo,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Sign-in button
//                   SizedBox(
//                     width: double.infinity,
//                     child: CustomButton(
//                         title: "Login",
//                         onTap: () async {
//                           if (_formKey.currentState!.validate()) {
//                             sendOTP();
//                           }
//                         }),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               // Sign up option
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't Have an Account? "),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SignUpScreen())),
//                     child: const Text(
//                       'Sign up',
//                       style: TextStyle(
//                         color: Colors.indigo,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
