import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/dashboard/notes/screen/notes_screen.dart';
import 'package:studylink/dashboard/subject/controller/subject_controller.dart';
import 'package:studylink/dashboard/widgets/custom_appbar.dart';

import '../../../constants/color_constants.dart';

class SubjectScreen extends StatefulWidget {
  final String semsterID;

  const SubjectScreen({
    super.key,
    required this.semsterID,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SubjectController>(context, listen: false)
        .fetchSemesters(widget.semsterID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Subjects"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
        child: Column(
          children: [
            Text(
              "Select the subject you need to access study materials for.",
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87.withOpacity(0.6)),
            ),
            SizedBox(
              height: 36,
            ),
            Expanded(
              child: Consumer<SubjectController>(
                builder: (context, value, child) => value.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.primaryColor,
                        ),
                      )
                    : value.subjects!.isEmpty
                        ? Center(
                            child: Text(
                              "No Subjects",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 8,
                            ),
                            itemCount: value.subjects?.length ?? 0,
                            itemBuilder: (context, index) {
                              final data = value.subjects?[index];
                              return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotesScreen(
                                              subjectId: data?.subjectId ?? '',
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
                                        .withOpacity(0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data?.subjectName?.toUpperCase() ??
                                              '',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: ColorConstants.primaryColor,
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
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
