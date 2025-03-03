// year_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studylink/teacher/screens/semester_screen.dart';

import '../constants/color_constants.dart';

class YearSelectionScreen extends StatelessWidget {
  final String departmentId;
  // final String departmentName;

  const YearSelectionScreen({
    super.key,
    required this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Select Year',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorConstants.primaryColor,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 2,
                    color: ColorConstants.secondaryColor.withOpacity(0.7),
                  )),
              title: Center(
                  child: Text(
                '2019-2023',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SemesterListScreen(
                      year: '2019-2023',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 2,
                    color: ColorConstants.secondaryColor.withOpacity(0.7),
                  )),
              title: Center(
                child: Text(
                  '2024-Current',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SemesterListScreen(
                      year: '20247-Current',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
