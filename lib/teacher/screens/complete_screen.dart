import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/constants/color_constants.dart';
import 'package:studylink/teacher/controllers/auth_controller.dart';
import 'package:studylink/teacher/core/utils.dart';
import 'package:studylink/teacher/screens/login_screen.dart';




import '../../auth/widgets/custom_button.dart';
import '../models/user_model.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumber = TextEditingController();
  String? selectedDepartment;
  final bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneNumber.dispose();
  }



  void _saveProfile(BuildContext context) async {
    final authProvider =
        Provider.of<TeachersAuthenticationProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel(
      uid: "",
      name: nameController.text.trim(),
      email: user?.email,
      phoneNumber: phoneNumber.text.trim(),
      department: selectedDepartment,
      approval: false,
    );

   

    authProvider.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(20).copyWith(bottom: 0),
              content: SizedBox(
                height: 250,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                        height: 150,
                        width: 150,
                        child: SvgPicture.asset(
                          "assets/icons/undraw_pending-approval_6cdu.svg",
                        )),
                    Text(
                      'Profile saved! Awaiting admin approval.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        title: "Back to login",
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeacherLoginScreen(),
                              ));
                        }))
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Complete your Profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                "Complete your profile to get the most out of StudyLink – tailored just for you! 🎓",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Input fields card
              Column(
                children: [
                  CustomTextfield(
                    label: "Full Name",
                    hint: "Full Name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    label: "Email",
                    hint: "Email",
                    value: user?.email,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    label: "Phone Number",
                    hint: "Phone Number",
                    controller: phoneNumber,
                  ),
                  const SizedBox(height: 15),
                  CustomDropdownWidget(
                    title: "Department",
                    hintText: "Department",
                    value: selectedDepartment,
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                    items: Utils.departments
                        .map(
                          (e) => DropdownMenuItem(
                              value: e.value, child: Text(e.label!)),
                        )
                        .toList(),
                    validator: (val) {
                      if (val == null) {
                        return "Select a Grade";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Submit button
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: ColorConstants.primaryColor,
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            title: "Submit",
                            onTap: () => _saveProfile(context),
                          )),
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
