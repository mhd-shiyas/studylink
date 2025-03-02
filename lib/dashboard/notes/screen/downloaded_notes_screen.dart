import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:studylink/constants/color_constants.dart';

import '../../widgets/custom_appbar.dart';

class DownloadedNotesScreen extends StatefulWidget {
  const DownloadedNotesScreen({super.key});

  @override
  _DownloadedNotesScreenState createState() => _DownloadedNotesScreenState();
}

class _DownloadedNotesScreenState extends State<DownloadedNotesScreen> {
  List<Map<String, String>> downloadedNotes = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedNotes();
  }

  // ✅ Load Downloaded Files
  Future<void> _loadDownloadedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedFiles =
        prefs.getStringList('downloaded_notes') ?? [];

    setState(() {
      downloadedNotes = downloadedFiles
          .map((file) => Map<String, String>.from(jsonDecode(file)))
          .toList();
    });
  }

  // ✅ Open Downloaded File
  void _openFile(String filePath) {
    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: "Downloaded Notes",
      ),
      body: downloadedNotes.isEmpty
          ? Center(child: Text("No downloaded notes found"))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemCount: downloadedNotes.length,
                itemBuilder: (context, index) {
                  final note = downloadedNotes[index];
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorConstants.secondaryColor.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note['name'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.primaryColor,
                                ),
                              ),
                              AutoSizeText(
                                note['path'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedFolderOpen,
                            color: ColorConstants.primaryColor,
                          ),
                          onPressed: () => _openFile(note['path']!),
                        ),
                      ],
                    ),
                  );

                  // ListTile(
                  //   title: ,
                  //   subtitle: ,
                  //   trailing:
                  // );
                },
              ),
            ),
    );
  }
}
