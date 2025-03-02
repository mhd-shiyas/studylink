import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/screens/department_screen.dart';
import 'package:studylink/teacher/screens/uploaded_screen.dart';

import '../constants/color_constants.dart';
import '../controllers/user_controller.dart';
import 'profile_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({
    super.key,
  });

  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  bool userStatus = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersUserController>(context, listen: false)
        .fetchUser(user!.uid);
    userStatus =
        await Provider.of<TeachersUserController>(context, listen: false)
            .checkUserStatus(user!.uid);
    // setState(() {});
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorConstants.primaryColor,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('teachers')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.primaryColor,
                  ),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    "No Data Found",
                    textAlign: TextAlign.center,
                  ),
                );
              }

              var data = snapshot.data;

              return data?["approvel"]
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadedNotesScreen(
                                    teacherId: user!.uid,
                                  ),
                                )),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ColorConstants.secondaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  'Uploaded Files',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DepartmentListScreen(),
                                )),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ColorConstants.primaryColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Upload Files',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Your account is pending approvel or has been rejected.",
                        textAlign: TextAlign.center,
                      ),
                    );
            },
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(4.0).copyWith(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: ColorConstants.secondaryColor.withOpacity(0.3),
                width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BottomNavigationBar(
              elevation: 10,
              //  unselectedItemColor: Colors.black38,
              selectedItemColor: ColorConstants.primaryColor,
              unselectedLabelStyle: GoogleFonts.montserrat(),
              selectedLabelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
              showUnselectedLabels: false,
              showSelectedLabels: false,
              currentIndex: 0,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/house-fill.svg",
                        color: ColorConstants.primaryColor,
                        height: 25,
                        width: 25,
                      ),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.primaryColor,
                        ),
                      )
                    ],
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/user.svg",
                      height: 25,
                      width: 25,
                    ),
                    label: 'Profile'),
              ],
              onTap: (index) {
                switch (index) {
                  case 0: // Home

                    break;

                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user!.uid),
                      ),
                    );
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
