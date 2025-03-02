import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/constants/color_constants.dart';
import 'package:studylink/dashboard/semesters/controller/semester_controller.dart';
import 'package:studylink/dashboard/subject/screen/subject_screen.dart';

import '../../widgets/custom_appbar.dart';

class SemesterScreen extends StatefulWidget {
  final String departmentID;
  final String year;
  const SemesterScreen({
    super.key,
    required this.departmentID,
    required this.year,
  });

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SemesterController>(context, listen: false)
        .fetchSemesters(widget.departmentID, widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: "Semesters",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select the semester you need to access study materials for.",
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87.withOpacity(0.6)),
            ),
            SizedBox(
              height: 36,
            ),
            Expanded(
              child: Consumer<SemesterController>(
                builder: (context, value, child) {
                  return value.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.primaryColor,
                          ),
                        )
                      : value.semesters!.isEmpty
                          ? Center(
                              child: Text(
                                "No Semesters",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: value.semesters?.length ?? 0,
                              itemBuilder: (context, index) {
                                final data = value.semesters?[index];
                                return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SubjectScreen(
                                                semsterID:
                                                    data?.semesterId ?? '',
                                              ))),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorConstants.primaryColor
                                            .withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      color: ColorConstants.secondaryColor
                                          .withOpacity(0.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book,
                                          color: ColorConstants.primaryColor,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            data?.semesterName?.toUpperCase() ??
                                                '',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  ColorConstants.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: ColorConstants.primaryColor,
                                          weight: 10,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
