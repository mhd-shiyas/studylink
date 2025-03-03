import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studylink/constants/color_constants.dart';

import '../../core/utils.dart';
import '../../dashboard/home/screens/home_screen.dart';
import '../controllers/auth_controller.dart';
import '../model/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_dropdown_widget.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumber = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneNumber.dispose();
  }

  String? selectedCourse;
  String? selectedYear;

  void storeData(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    UserModel userModel = UserModel(
      uid: "",
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      course: selectedCourse,
      yearOfAdmission: selectedYear,
    );

    authProvider.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        authProvider.setSignIn().then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading =
    //     Provider.of<AuthProvider>(context, listen: true).isCompleteLoading;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            // isLoading == true
            //     ? const Center(
            //         child: CircularProgressIndicator(
            //           color: Colors.purple,
            //         ),
            //       )
            //     :
            SingleChildScrollView(
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
                    // controller: emailController,
                    value: user!.email,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    label: "Phone Number",
                    hint: "Phone Number",
                    keyboardType: TextInputType.number,
                    controller: phoneNumber,
                  ),
                  const SizedBox(height: 15),
                  CustomDropdownWidget(
                    title: "Course",
                    hintText: "Course",
                    value: selectedCourse,
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value;
                      });
                    },
                    items: Utils.courses
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Select Year:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: selectedYear == '2019-2023',
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value! ? '2019-2023' : null;
                          });
                        },
                      ),
                      const Text(
                        '2019-2023',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Checkbox(
                        activeColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: selectedYear == '2024-Current',
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value! ? '2024-Current' : null;
                          });
                        },
                      ),
                      const Text(
                        '2024-Current',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Submit button
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: "Submit",
                        onTap: () => storeData(context),
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
