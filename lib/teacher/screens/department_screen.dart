import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/screens/year_selection_screen.dart';


import '../constants/color_constants.dart';
import '../controllers/home_controller.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersHomeController>(context, listen: false).fetchDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Departments',
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
            return value.isDepartmentLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    ),
                  )
                : value.department!.isEmpty
                    ? Center(
                        child: Text(
                          "No Departments Available",
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
                              "Select the department you need to upload study materials.",
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
                                                  YearSelectionScreen(
                                                departmentId:
                                                    item?["departmentId"] ?? '',
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
                                                color: ColorConstants
                                                    .secondaryColor
                                                    .withOpacity(0.7),
                                                width: 2,
                                              )),
                                          child: Center(
                                            child: AutoSizeText(
                                              item?["dep_name"] ?? '',
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
