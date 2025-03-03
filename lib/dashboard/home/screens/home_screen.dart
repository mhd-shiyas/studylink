import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:studylink/auth/controllers/user_controller.dart';
import 'package:studylink/constants/color_constants.dart';
import 'package:studylink/dashboard/home/controller/home_controller.dart';
import 'package:studylink/dashboard/home/screens/liked_screen.dart';
import 'package:studylink/dashboard/home/widgets/custom_drawer.dart';
import 'package:studylink/dashboard/profile/screens/profile_screen.dart';

import '../../gemini/gemini_chat_screen.dart';
import '../../notes/screen/downloaded_notes_screen.dart';
import '../../semesters/screens/semesters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<UserController>(context, listen: false).fetchUser(user!.uid);
    Provider.of<HomeController>(context, listen: false).fetchDepartment();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Consumer<UserController>(
              builder: (context, value, child) {
                return Text(
                  "Hi, ${value.user?.name?.toUpperCase() ?? ''}",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                );
              },
            ),
            SizedBox(
                height: 30,
                width: 30,
                child: Image.asset("assets/icons/wave.png")),
          ],
        ),
        leading: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userId: "BOCI5FNOfpXGCtI6mdedf3irO1s2",
                      ))),
          child: Container(
            margin: const EdgeInsets.all(10).copyWith(right: 0),
            padding: const EdgeInsets.all(4),
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/icons/user.svg",
              height: 10,
              width: 10,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchInitialData,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: ColorConstants.secondaryColor.withOpacity(0.7)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Unlock Your \nLearning Potential",
                        style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: ColorConstants.primaryColor),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                            height: 45,
                            width: 45,
                            child: Image.asset("assets/icons/rocket.png")),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Departments',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Consumer<HomeController>(
                  builder: (context, value, child) {
                    return value.isloading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.primaryColor,
                            ),
                          )
                        : ListView.separated(
                            //padding: const EdgeInsets.all(16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 2,
                            //   crossAxisSpacing: 16.0,
                            //   mainAxisSpacing: 16.0,
                            // ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 12,
                            ),
                            itemCount: value.department?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = value.department?[index];
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SemesterScreen(
                                                  departmentID:
                                                      item?["departmentId"] ??
                                                          '',
                                                  year: userProvider.user
                                                          ?.yearOfAdmission ??
                                                      '',
                                                ))),
                                    child: Container(
                                      height: 50,
                                      padding: EdgeInsets.all(8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: ColorConstants.secondaryColor
                                                .withOpacity(0.7),
                                            width: 2,
                                          )),
                                      child: Center(
                                        child: AutoSizeText(
                                          item?["dep_name"].toUpperCase() ?? '',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
              unselectedItemColor: Colors.black38,
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
                      "assets/icons/heart.svg",
                      height: 25,
                      width: 25,
                    ),
                    label: 'Like'),
                BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDownload01,
                      color: ColorConstants.primaryColor,
                    ),
                    label: 'Dowmloaded'),
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
                  case 1: // Like
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikedScreen(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DownloadedNotesScreen(),
                      ),
                    );
                    break;
                  case 3:
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
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          backgroundColor: ColorConstants.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeminiChatScreen()),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedBubbleChat,
                color: Colors.white,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "Chat with AI",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
