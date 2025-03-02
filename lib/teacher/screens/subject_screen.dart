import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/constants/color_constants.dart';
import 'package:studylink/teacher/screens/pdf_adding_screen.dart';


import '../controllers/home_controller.dart';

class SubjectListScreen extends StatefulWidget {
  final String semesterID;
  const SubjectListScreen({
    super.key,
    required this.semesterID,
  });

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersHomeController>(context, listen: false)
        .fetchSubject(widget.semesterID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Subjects',
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
            return value.isSubjectLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    ),
                  )
                : value.subjects!.isEmpty
                    ? Center(
                        child: Text(
                          "No Subjects Available",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchInitialData,
                        child: Column(
                          children: [
                            Text(
                              "Select the subjects you need to upload study materials.",
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
                                itemCount: value.subjects?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final item = value.subjects?[index];
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfAddingScreen(
                                            subjectId: item?.subjectId ?? '',
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
                                          item?.subjectName ?? '',
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
