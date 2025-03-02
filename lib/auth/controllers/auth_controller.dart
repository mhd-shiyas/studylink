import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../../core/utils.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCompleteLoading = false;
  bool get isCompleteLoading => _isCompleteLoading;

  String? _uid;
  String get uid => _uid!;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences data = await SharedPreferences.getInstance();
    _isSignedIn = data.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        _uid = userCredential.user!.uid;
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = _firebaseAuth.currentUser?.uid;
      onSuccess();

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    _isCompleteLoading = true;
    notifyListeners();
    try {
      _uid = _firebaseAuth.currentUser?.uid;
      userModel.uid = _uid!;
      userModel.email = _firebaseAuth.currentUser?.email ?? '';

      _userModel = userModel;
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((_) {
        onSuccess();
        _isCompleteLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future saveUserDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        "user_model", jsonEncode(userModel.toMap()));
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Password reset link sent to $email");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    return snapshot.exists;
  }

  Future<void> signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    sharedPreferences.clear();
  }
}






// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../core/utils.dart';
// import '../otp_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../model/user_model.dart';

// class AuthenticationProvider with ChangeNotifier {
//   bool _isSignedIn = false;
//   bool get isSignedIn => _isSignedIn;
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   bool _isCompleteLoading = false;
//   bool get isCompleteLoading => _isCompleteLoading;
//   String? _uid;
//   String get uid => _uid!;
//   UserModel? _userModel;
//   UserModel get userModel => _userModel!;

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   AuthenticationProvider() {
//     checkSign();
//   }

//   void checkSign() async {
//     final SharedPreferences data = await SharedPreferences.getInstance();
//     _isSignedIn = data.getBool("is_signedin") ?? false;
//     notifyListeners();
//   }

//   Future setSignIn() async {
//     final SharedPreferences s = await SharedPreferences.getInstance();
//     s.setBool("is_signedin", true);
//     _isSignedIn = true;
//     notifyListeners();
//   }

//   void signInWithPhone(BuildContext context, String? phoneNumber) async {
//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
//           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//         },
//         verificationFailed: (error) {
//           throw Exception(error.message);
//         },
//         codeSent: (verificationId, forceResendingToken) async {
//           // String? smsCode;

//           // PhoneAuthCredential credential = PhoneAuthenticationProvider.credential(
//           //     verificationId: verificationId, smsCode: smsCode ?? '');
//           // await _firebaseAuth.signInWithCredential(credential);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     OtpScreen(verificationId: verificationId)),
//           );
//         },
//         codeAutoRetrievalTimeout: (verificationId) {},
//       );
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//     }
//   }

//   void verifyOtp({
//     required BuildContext context,
//     required String verificationId,
//     required String userOtp,
//     required Function onSuccess,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       PhoneAuthCredential creds = PhoneAuthenticationProvider.credential(
//         verificationId: verificationId,
//         smsCode: userOtp,
//       );
//       User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

//       if (user != null) {
//         _uid = user.uid;
//         onSuccess();
//       }
//       _isLoading = false;
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//       _isLoading = false;
//       notifyListeners();
//     }
//   }




//   void saveUserDataToFirebase({
//     required BuildContext context,
//     required UserModel userModel,
//     required Function onSuccess,
//   }) async {
//     _isCompleteLoading = true;
//     notifyListeners();
//     try {
//       userModel.phoneNumber = _firebaseAuth.currentUser?.phoneNumber ?? '';
//       userModel.uid = _firebaseAuth.currentUser?.uid;

//       _userModel = userModel;
//       await _firebaseFirestore
//           .collection("users")
//           .doc(_uid)
//           .set(userModel.toMap())
//           .then(
//         (value) {
//           onSuccess();
//           _isCompleteLoading = false;
//           notifyListeners();
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message.toString());
//     }
//   }

//   Future saveUserDataToSP() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences.setString(
//         "user_model", jsonEncode(userModel.toMap()));
//   }

//   Future userSignOut() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     await _firebaseAuth.signOut();
//     _isSignedIn = false;
//     notifyListeners();
//     sharedPreferences.clear();
//   }
// }







// // import 'package:flutter/material.dart';

// // class AuthController {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// //   /// Method to send OTP to a given phone number
// //   Future<void> sendOtp(String phoneNumber, Function(String) onCodeSent,
// //       BuildContext context) async {
// //     try {
// //       await _auth.verifyPhoneNumber(
// //         phoneNumber: phoneNumber,
// //         verificationCompleted: (PhoneAuthCredential credential) async {
// //           await _auth.signInWithCredential(credential);
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //                 content: Text(
// //                     "Phone number automatically verified and user signed in.")),
// //           );
// //         },
// //         verificationFailed: (FirebaseAuthException e) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("Verification failed: ${e.message}")),
// //           );
// //         },
// //         codeSent: (String verificationId, int? resendToken) {
// //           onCodeSent(verificationId);
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("OTP sent to $phoneNumber")),
// //           );
// //         },
// //         codeAutoRetrievalTimeout: (String verificationId) {},
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to send OTP: ${e.toString()}")),
// //       );
// //     }
// //   }



// //     Future<void> verifyOtp(
// //       String verificationId, String otp, BuildContext context) async {
// //     try {
// //       PhoneAuthCredential credential = PhoneAuthenticationProvider.credential(
// //         verificationId: verificationId,
// //         smsCode: otp,
// //       );

// //       await _auth.signInWithCredential(credential);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("OTP verified and user signed in.")),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Invalid OTP: ${e.toString()}")),
// //       );
// //     }
// //   }
// // }

// //   Future<String> verifyOTP({
// //     required String verifyId,
// //     required String otp,
// //   }) async {
// //     try {
// //       final PhoneAuthCredential authCredential =
// //           PhoneAuthenticationProvider.credential(verificationId: verifyId, smsCode: otp);

// //       final UserCredential userCredential =
// //           await _auth.signInWithCredential(authCredential);
// //       if (userCredential.user != null) {
// //         await storePhoneNumber(userCredential.user?.phoneNumber ?? );
// //         return 'success';
// //       } else {
// //         return 'Error in OTP';
// //       }
// //     } catch (e) {
// //       return e.toString();
// //     }
// //   }
//   /// Method to verify the OTP








// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class AuthController {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   Future<void> sendOTP(String phoneNo, Function(String) onCodeSent) async {
// //     await _auth.verifyPhoneNumber(
// //       timeout: const Duration(seconds: 40),
// //       phoneNumber: "+91$phoneNo",
// //       verificationCompleted: (creadential) {},
// //       verificationFailed: (e) {},
// //       codeSent: (verificationId, resendToken) {
// //         onCodeSent(verificationId);
// //       },
// //       codeAutoRetrievalTimeout: (verificationId) {},
// //     );
// //   }

// //   Future<String> verifyOTP({
// //     required String verifyId,
// //     required String otp,
// //   }) async {
// //     try {
// //       final PhoneAuthCredential authCredential =
// //           PhoneAuthenticationProvider.credential(verificationId: verifyId, smsCode: otp);

// //       final UserCredential userCredential =
// //           await _auth.signInWithCredential(authCredential);
// //       if (userCredential.user != null) {
// //         await storePhoneNumber(userCredential.user?.phoneNumber ?? );
// //         return 'success';
// //       } else {
// //         return 'Error in OTP';
// //       }
// //     } catch (e) {
// //       return e.toString();
// //     }
// //   }

// //   Future<void> storePhoneNumber(String phoneNo) async {
// //     try {
// //       await _firestore
// //           .collection('users')
// //           .doc(phoneNo)
// //           .set({'phoneNumber': phoneNo});
// //     } catch (e) {
// //       e.toString();
// //     }
// //   }
// // }
