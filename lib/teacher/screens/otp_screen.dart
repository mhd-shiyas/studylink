// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';

// import '../constants/color_constants.dart';
// import '../controllers/auth_controller.dart';
// import '../core/utils.dart';
// import '../widgets/custom_button.dart';
// import 'complete_screen.dart';
// import 'home_screen.dart';

// class OtpScreen extends StatefulWidget {
//   final String verificationId;

//   OtpScreen({required this.verificationId});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   // final TextEditingController otpController = TextEditingController();

//   String? otp;

//   void verifyOtp(BuildContext context, String userOtp) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.verifyOtp(
//         context: context,
//         verificationId: widget.verificationId,
//         userOtp: userOtp,
//         onSuccess: () {
//           authProvider.checkExistingUser().then((value) async {
//             if (value == true) {
//               authProvider.getDataFromFirestore().then(
//                     (value) => authProvider.saveUserDataToSP().then(
//                           (value) => authProvider.setSignIn().then(
//                                 (value) => Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HomeScreen(),
//                                   ),
//                                   (route) => false,
//                                 ),
//                               ),
//                         ),
//                   );
//             } else {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CompleteScreen(),
//                 ),
//                 (route) => false,
//               );
//             }
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading =
//         Provider.of<AuthProvider>(context, listen: true).isLoading;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0).copyWith(top: 50),
//         child: isLoading == true
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: ColorConstants.primaryColor,
//                 ),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: const Icon(
//                         Icons.arrow_back,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                       height: 200,
//                       width: 200,
//                       child: SvgPicture.asset(
//                         "assets/images/otp.svg",
//                       )),
//                   Text(
//                     "Verification",
//                     style: GoogleFonts.montserrat(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   Text(
//                     "Enter the OTP send to your phone number.",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.montserrat(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Pinput(
//                     length: 6,
//                     showCursor: true,
//                     defaultPinTheme: PinTheme(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: ColorConstants.primaryColor,
//                             )),
//                         textStyle: GoogleFonts.montserrat(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         )),
//                     onCompleted: (value) {
//                       setState(() {
//                         otp = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: CustomButton(
//                       title: "Verify",
//                       onTap: () {
//                         if (otp != null) {
//                           verifyOtp(context, otp ?? '');
//                         } else {
//                           showSnackBar(context, "Enter 6-Digit code");
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Didn't receive any code? "),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text(
//                           'Resend OTP',
//                           style: TextStyle(
//                             color: ColorConstants.primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // CustomTextfield(
//                   //   onChanged: (value) {
//                   //     setState(() {
//                   //       phoneController.text = value;
//                   //     });
//                   //   },
//                   //   fontStyle: GoogleFonts.montserrat(
//                   //     fontSize: 15,
//                   //     fontWeight: FontWeight.bold,
//                   //   ),
//                   //   label: "Phone Number",
//                   //   hint: "Phone Number",
//                   //   controller: phoneController,
//                   //   prefix: Container(
//                   //     padding: const EdgeInsets.all(8).copyWith(top: 14, left: 12),
//                   //     child: InkWell(
//                   //       onTap: () {
//                   //         showCountryPicker(
//                   //             context: context,
//                   //             countryListTheme:
//                   //                 const CountryListThemeData(bottomSheetHeight: 400),
//                   //             onSelect: (val) {
//                   //               selecetCountry = val;
//                   //             });
//                   //       },
//                   //       child: Text(
//                   //         "${selecetCountry.flagEmoji} +${selecetCountry.phoneCode}",
//                   //         style: GoogleFonts.montserrat(
//                   //           fontSize: 15,
//                   //           fontWeight: FontWeight.bold,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   //   suffix: otpController.text.length == 6
//                   //       ? Container(
//                   //           height: 30,
//                   //           width: 30,
//                   //           margin: const EdgeInsets.all(20),
//                   //           decoration: const BoxDecoration(
//                   //             shape: BoxShape.circle,
//                   //             color: Colors.green,
//                   //           ),
//                   //           child: const Icon(
//                   //             Icons.done,
//                   //             color: Colors.white,
//                   //             size: 20,
//                   //           ),
//                   //         )
//                   //       : null,
//                   // ),
//                   // TextField(
//                   //   controller: _otpController,
//                   //   keyboardType: TextInputType.number,
//                   //   decoration: const InputDecoration(
//                   //     labelText: "Enter OTP",
//                   //     border: OutlineInputBorder(),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // class OtpScreen extends StatefulWidget {
// //   @override
// //   _OtpScreenState createState() => _OtpScreenState();
// // }

// // class _OtpScreenState extends State<OtpScreen> {
// //   final TextEditingController _otpController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               Color(0xFF6A11CB),
// //               Color(0xFF2575FC),
// //             ],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "Verify Your OTP",
// //                   style: TextStyle(
// //                     fontSize: 24.0,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 SizedBox(height: 10.0),
// //                 Text(
// //                   "Enter the OTP sent to your mobile number",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 16.0,
// //                     color: Colors.white.withOpacity(0.8),
// //                   ),
// //                 ),
// //                 SizedBox(height: 30.0),
// //                 // Row(
// //                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 //   children: List.generate(6, (index) => _otpTextField(context, index)),
// //                 // ),
// //                 SizedBox(height: 30.0),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Handle OTP verification logic here
// //                     print("Entered OTP: ${_otpController.text}");
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(30.0),
// //                     ),
// //                     padding:
// //                         EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
// //                   ),
// //                   child: Text(
// //                     "Verify",
// //                     style: TextStyle(
// //                       color: Color(0xFF2575FC),
// //                       fontSize: 18.0,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20.0),
// //                 TextButton(
// //                   onPressed: () {
// //                     // Handle resend OTP logic
// //                     print("Resend OTP");
// //                   },
// //                   child: Text(
// //                     "Resend OTP",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 16.0,
// //                       decoration: TextDecoration.underline,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
