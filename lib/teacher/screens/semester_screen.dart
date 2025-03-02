import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/screens/subject_screen.dart';

import '../constants/color_constants.dart';
import '../controllers/home_controller.dart';

class SemesterListScreen extends StatefulWidget {
  final String year;
  const SemesterListScreen({
    super.key,
    required this.year,
  });

  @override
  State<SemesterListScreen> createState() => _SemesterListScreenState();
}

class _SemesterListScreenState extends State<SemesterListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersHomeController>(context, listen: false)
        .fetchSemesters(widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Semesters',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ColorConstants.primaryColor,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<TeachersHomeController>(
          builder: (context, value, child) {
            return value.isSemesterLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    ),
                  )
                : value.semesters!.isEmpty
                    ? Center(
                        child: Text(
                          "No Semesters Available",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: ColorConstants.primaryColor,
                        onRefresh: fetchInitialData,
                        child: Column(
                          children: [
                            Text(
                              "Select the semester you need to upload study materials.",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87.withOpacity(0.6)),
                            ),
                            SizedBox(
                              height: 36,
                            ),
                            Expanded(
                              child: ListView.separated(
                                //padding: const EdgeInsets.all(16.0),
                                shrinkWrap: true,
                                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                //   crossAxisCount: 2,
                                //   crossAxisSpacing: 16.0,
                                //   mainAxisSpacing: 16.0,
                                // ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 12,
                                ),
                                itemCount: value.semesters?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final item = value.semesters?[index];
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubjectListScreen(
                                            semesterID: item?.semesterId ?? '',
                                          ),
                                        )),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      height: 70,
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
                                        child: Text(
                                          item?.semesterName ?? '',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
