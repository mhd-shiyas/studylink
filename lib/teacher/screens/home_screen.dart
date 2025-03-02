import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/screens/department_screen.dart';
import 'package:studylink/teacher/screens/uploaded_screen.dart';

import '../constants/color_constants.dart';
import '../controllers/home_controller.dart';
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
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersUserController>(context, listen: false)
        .fetchUser(user!.uid);
  }
  // final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // String? _selectedSubjectId;
  // String? _fileName;
  // Uint8List? _fileData;

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   super.dispose();
  // }

  // Future<void> _selectFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
  //   );
  //   if (result != null) {
  //     setState(() {
  //       _fileName = result.files.first.name;
  //       _fileData = result.files.first.bytes;
  //     });
  //   }
  // }

  // Future<void> _uploadModule(HomeController controller) async {
  //   if (_titleController.text.isEmpty ||
  //       _descriptionController.text.isEmpty ||
  //       _selectedSubjectId == null ||
  //       _fileData == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Please fill all fields and select a file')),
  //     );
  //     return;
  //   }

  //   try {
  //     await controller.uploadFile(
  //       teacherId: widget.teacherId,
  //       teacherName: widget.teacherName,
  //       title: _titleController.text,
  //       description: _descriptionController.text,
  //       subjectId: _selectedSubjectId!,
  //       fileData: _fileData!,
  //       fileName: _fileName!,
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('File uploaded successfully')),
  //     );

  //     // Reset form
  //     _titleController.clear();
  //     _descriptionController.clear();
  //     setState(() {
  //       _selectedSubjectId = null;
  //       _fileName = null;
  //       _fileData = null;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

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
        child: SingleChildScrollView(
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
