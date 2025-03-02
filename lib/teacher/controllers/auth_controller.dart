import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class TeachersAuthenticationProvider with ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCompleteLoading = false;
  bool get isCompleteLoading => _isCompleteLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  AuthenticationProvider() {
    checkSign();
  }

  void subscribeToApprovalNotification(String teacherId) async {
    await _firebaseMessaging.subscribeToTopic("teacher_$teacherId");
    print("✅ Subscribed to teacher approval notifications!");
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

  // Login method
  Future<void> login(String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure the teacher is approved before logging in
      DocumentSnapshot userDoc = await _firebaseFirestore
          .collection('teachers')
          .doc(user.user?.uid)
          .get();

      if (userDoc.exists && userDoc['status'] == "Approved") {
        notifyListeners();
      } else {
        throw Exception(
            'Your account is pending approval or has been rejected.');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Signup method with admin request
  Future<void> signup(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String teacherId = userCredential.user!.uid;
      String? fcmToken = await _firebaseMessaging.getToken();
      // Add a pending request for admin approval
      await _firebaseFirestore
          .collection('teachers_pending_approvals')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'status': 'pending',
        "teacherId": teacherId,
        "fcmToken": fcmToken, // ✅ Store the FCM token
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    await _firebaseAuth.signOut();
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
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('teachers').doc(_uid).get();

      if (userDoc.exists && userDoc['approvel'] == true) {
        notifyListeners();
      } else {
        throw Exception(
            'Your account is pending approvel or has been rejected.');
      }
      onSuccess();

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("teachers").doc(_uid).get();
    return snapshot.exists;
  }

  // Future<bool> checkExistingUser() async {
  //   DocumentSnapshot snapshot =
  //       await _firebaseFirestore.collection("teachers").doc(_uid).get();
  //   if (snapshot.exists) {
  //     print("USER EXISTS");
  //     return true;
  //   } else {
  //     print("NEW USER");
  //     return false;
  //   }
  // }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("teachers")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        uid: snapshot["uid"],
        name: snapshot["name"],
        email: snapshot["email"],
        phoneNumber: snapshot["phoneNumber"],
        department: snapshot["department"],
        approval: snapshot["approvel"],
      );
      _uid = userModel.uid;
    });
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    _isCompleteLoading = true;
    notifyListeners();
    try {
      _uid = _firebaseAuth.currentUser?.uid;
      userModel.uid = _uid;
      userModel.email = userModel.email ?? '';

      _userModel = userModel;
      await _firebaseFirestore
          .collection("teachers")
          .doc(_uid)
          .set(userModel.toMap())
          .then(
        (_) {
          onSuccess();
          _isCompleteLoading = false;
          notifyListeners();
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future saveUserDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        "teacher_model", jsonEncode(userModel.toMap()));
  }

  Future userSignOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    sharedPreferences.clear();
  }
}
