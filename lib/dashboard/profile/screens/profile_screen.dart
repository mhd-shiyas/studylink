import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/auth/controllers/user_controller.dart';
import 'package:studylink/auth/screens/user_selection_screen.dart';
import 'package:studylink/auth/widgets/custom_button.dart';
import 'package:studylink/dashboard/widgets/custom_appbar.dart';

import '../../../auth/controllers/auth_controller.dart';
import '../../../constants/color_constants.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Profile",
      ),
      body: Consumer<UserController>(
        builder: (context, value, child) {
          if (value.isloading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primaryColor,
              ),
            );
          }
          // if(value.user == null){
          //   return const Center()
          // }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personal Details",
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: ColorConstants.primaryColor),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.secondaryColor.withOpacity(0.4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileDetailsWidget(
                        title: "Name",
                        value: value.user?.name ?? '',
                      ),
                      ProfileDetailsWidget(
                        title: "Mobile Number",
                        value: value.user?.phoneNumber ?? '',
                      ),
                      ProfileDetailsWidget(
                        title: "Email",
                        value: value.user?.email ?? '',
                      ),
                      ProfileDetailsWidget(
                        title: "Course",
                        value: value.user?.course ?? '',
                      ),
                      ProfileDetailsWidget(
                        title: "Year",
                        value: value.user?.yearOfAdmission ?? '',
                        isLine: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 36,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      title: "Logout",
                      onTap: () {
                        authProvider.signOut().then(
                              (value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserSelectionScreen(),
                                  )),
                            );
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetailsWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isLine;
  const ProfileDetailsWidget({
    super.key,
    required this.title,
    required this.value,
    this.isLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        isLine == true
            ? Divider(
                color: Colors.grey.withOpacity(0.2),
              )
            : SizedBox(),
      ],
    );
  }
}
