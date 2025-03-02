import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studylink/dashboard/notes/model/notes_model.dart';
import 'package:studylink/dashboard/notes/controller/notes_controller.dart';

import '../../../constants/color_constants.dart';
import '../../widgets/custom_appbar.dart';

class NotesScreen extends StatefulWidget {
  final String subjectId;

  const NotesScreen({
    super.key,
    required this.subjectId,
  });

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, bool> downloadedNotes = {};

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<NotesController>(context, listen: false)
        .fetchNotes(widget.subjectId, user!.uid);
  }

  Future<void> _downloadFile(
      String fileUrl, String fileName, BuildContext context) async {
    // ✅ Request Storage Permission
    if (!await _requestStoragePermission(context)) return;

    // ✅ Get Downloads Directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir =
          Directory('/storage/emulated/0/Download'); // Android Downloads folder
    } else {
      downloadsDir =
          await getApplicationDocumentsDirectory(); // iOS documents folder
    }

    // ✅ Extract File Extension from URL
    String? fileExtension = fileUrl.split('.').last.split('?').first;
    String fullFileName = '$fileName.$fileExtension';
    final filePath = '${downloadsDir.path}/$fullFileName';

    final file = File(filePath);

    // ✅ Check if file already exists
    if (await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File already downloaded!')),
      );
      return;
    }

    // ✅ Download the file
    try {
      Dio dio = Dio();
      await dio.download(fileUrl, filePath);

      // ✅ Save file details locally
      await _saveDownloadedFile(fullFileName, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Download complete! File saved as $fullFileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed! Error: $e')),
      );
    }
    await _saveDownloadedFile(fullFileName, filePath);
    await _loadDownloadedNotes(); // ✅ Reload the downloaded notes screen
  }

  Future<void> _loadDownloadedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedFiles =
        prefs.getStringList('downloaded_notes') ?? [];

    // Convert JSON strings to Map objects and remove duplicates
    List<Map<String, String>> uniqueFiles = {
      for (var file in downloadedFiles)
        Map<String, String>.from(jsonDecode(file))
    }.toList();

    setState(() {
      downloadedNotes = uniqueFiles as Map<String, bool>;
    });

    print("Loaded Unique Files: ${downloadedNotes.length}");
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true; // ✅ Permission granted
      }

      // For Android 11+ (Scoped Storage)
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true; // ✅ Permission granted
      }

      // Permission Denied
      if (await Permission.storage.isDenied ||
          await Permission.manageExternalStorage.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Storage permission is required to download files.')),
        );
        return false;
      }

      // Permission Permanently Denied (Show Settings)
      if (await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        _showPermissionDialog(context);
        return false;
      }
    }

    return true; // For iOS, storage permission is not required
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Storage Permission Required"),
        content: Text(
            "Please enable storage permission in app settings to download files."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Opens device settings 📱
              Navigator.pop(context);
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<bool> _isFileDownloaded(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> downloadedFiles =
        prefs.getStringList('downloaded_notes') ?? [];

    return downloadedFiles.any((filePath) => filePath.contains(fileName));
  }

  Future<void> _saveDownloadedFile(String fileName, String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedFiles =
        prefs.getStringList('downloaded_notes') ?? [];

    // Convert the list of JSON strings into a list of Maps
    List<Map<String, String>> filesList = downloadedFiles
        .map((file) => Map<String, String>.from(jsonDecode(file)))
        .toList();

    // ✅ Check if the file is already saved
    bool fileExists = filesList.any((file) => file['path'] == filePath);

    if (!fileExists) {
      // ✅ If not exists, add it
      Map<String, String> fileDetails = {'name': fileName, 'path': filePath};
      downloadedFiles.add(jsonEncode(fileDetails));

      await prefs.setStringList('downloaded_notes', downloadedFiles);
      print("File Saved: $fileName");
    } else {
      print("File Already Exists: $fileName");
    }
  }

  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          title: "Notes & PYQPS & YT Links",
        ),
        body: notesController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : notesController.notes.isEmpty &&
                    notesController.pyqp.isEmpty &&
                    notesController.ytNotes.isEmpty
                ? const Center(child: Text("No Notes Available"))
                : Column(
                    children: [
                      TabBar(
                        dividerColor: Colors.transparent,
                        onTap: (index) {
                          setState(() {
                            //currentIndex = index;
                          });
                        },
                        controller: _tabController,
                        padding: const EdgeInsets.all(20)
                            .copyWith(bottom: 0, top: 0),
                        labelColor: ColorConstants.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        indicatorColor: ColorConstants.primaryColor,
                        tabs: [
                          Tab(text: "Notes"),
                          Tab(text: "PYQP"),
                          Tab(text: "YT Link"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildSection("Notes", notesController.notes),
                            _buildSection("PYQP", notesController.pyqp),
                            _buildSection("YT Link", notesController.ytNotes),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSection(String title, List<NotesModel> notes) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return _buildNoteItem(note: notes[index]);
        },
      ),
    );
  }

  /// ✅ Build Each Note Item
  Widget _buildNoteItem({required NotesModel note}) {
    bool isDownloaded = downloadedNotes[note.fileURL] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.noteName ?? "Untitled",
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              note.description ?? "No Description",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder<bool>(
                    future: _isFileDownloaded(note.noteName ?? ''),
                    builder: (context, snapshot) {
                      bool isDownloaded = snapshot.data ?? false;

                      return note.noteType == "YT_Link"
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey.withOpacity(0.3),
                                        )),
                                    child: AutoSizeText(
                                      note.youtubeLink ?? '',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: note.youtubeLink ?? ''));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'YouTube link copied to clipboard!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedCopy01,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    size: 30,
                                    note.isLiked(user!.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: note.isLiked(user!.uid)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    Provider.of<NotesController>(context,
                                            listen: false)
                                        .toggleLike(user!.uid, note);
                                  },
                                ),
                              ],
                            )
                          : isDownloaded
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Downloaded",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await _downloadFile(note.fileURL!,
                                              note.noteName ?? '', context);
                                        },
                                        icon: Icon(Icons.download,
                                            size: 18, color: Colors.white),
                                        label: Text(
                                          "Download",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorConstants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12))),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        size: 30,
                                        note.isLiked(user!.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: note.isLiked(user!.uid)
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        Provider.of<NotesController>(context,
                                                listen: false)
                                            .toggleLike(user!.uid, note);
                                      },
                                    ),
                                  ],
                                );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Build Sections for Notes & PYQP
}








// class NotesScreen extends StatefulWidget {
//   final String subjectId;

//   const NotesScreen({
//     Key? key,
//     required this.subjectId,
//   }) : super(key: key);

//   @override
//   _NotesScreenState createState() => _NotesScreenState();
// }

// class _NotesScreenState extends State<NotesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     fetchInitialData();
//   }

//   Future<void> fetchInitialData() async {
//     Provider.of<NotesController>(context, listen: false)
//         .fetchNotes(widget.subjectId, user!.uid);
//   }

//   final user = FirebaseAuth.instance.currentUser;
//   TabController? _tabController;

//   @override
//   Widget build(BuildContext context) {
//     final notesController = Provider.of<NotesController>(context);

//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: const CustomAppbar(
//           title: "Notes & PYQP",
//         ),
//         body: notesController.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : notesController.notes.isEmpty &&
//                     notesController.pyqp.isEmpty &&
//                     notesController.ytNotes.isEmpty
//                 ? const Center(child: Text("No Notes Available"))
//                 : Column(
//                     children: [
//                       TabBar(
//                         dividerColor: Colors.transparent,
//                         onTap: (index) {
//                           setState(() {
//                             //currentIndex = index;
//                           });
//                         },
//                         controller: _tabController,
//                         padding: const EdgeInsets.all(20)
//                             .copyWith(bottom: 0, top: 0),
//                         labelColor: ColorConstants.primaryColor,
//                         unselectedLabelColor: Colors.grey,
//                         labelStyle: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         indicatorColor: ColorConstants.primaryColor,
//                         tabs: [
//                           Tab(text: "Notes"),
//                           Tab(text: "PYQP"),
//                           Tab(text: "YT Link"),
//                         ],
//                       ),
//                       Expanded(
//                         child: TabBarView(
//                           controller: _tabController,
//                           children: [
//                             _buildSection("Notes", notesController.notes),
//                             _buildSection("PYQP", notesController.pyqp),
//                             _buildSection("YT Link", notesController.ytNotes),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }

//   /// ✅ Build Sections for Notes & PYQP
//   Widget _buildSection(String title, List<NotesModel> notes) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           return _buildNoteItem(note: notes[index]);
//         },
//       ),
//     );
//   }

//   /// ✅ Build Each Note Item with Like Button
//   Widget _buildNoteItem({
//     required NotesModel note,
//     //  bool? isYtLink,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               note.noteName ?? "Untitled",
//               style:
//                   GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               note.description ?? "No Description",
//               style: GoogleFonts.inter(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Uploaded by: ${note.teacherName}",
//               style: GoogleFonts.inter(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 note.noteType == "YT_Link"
//                     ? Expanded(
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 width: 2,
//                                 color: Colors.grey.withOpacity(0.3),
//                               )),
//                           child: AutoSizeText(
//                             note.youtubeLink ?? '',
//                           ),
//                         ),
//                       )
//                     : Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () => _downloadFile(note.fileURL!),
//                           icon: const Icon(
//                             Icons.download,
//                             size: 18,
//                             color: Colors.white,
//                           ),
//                           label: Text("Download",
//                               style: GoogleFonts.inter(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               )),
//                           style: ElevatedButton.styleFrom(
//                             maximumSize: Size(double.infinity, 50),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             foregroundColor: Colors.white,
//                             backgroundColor: ColorConstants.primaryColor,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                           ),
//                         ),
//                       ),
//                 if (note.noteType == "YT_Link")
//                   SizedBox(
//                     width: 6,
//                   ),
//                 // ElevatedButton(
//                 //   onPressed: () => _downloadFile(note.fileURL!),
//                 //   child: const Text("Download"),
//                 // ),
//                 if (note.noteType == "YT_Link")
//                   InkWell(
//                     onTap: () {
//                       Clipboard.setData(
//                           ClipboardData(text: note.youtubeLink ?? ''));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('YouTube link copied to clipboard!'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     },
//                     child: HugeIcon(
//                       icon: HugeIcons.strokeRoundedCopy01,
//                       color: Colors.grey,
//                       size: 30,
//                     ),
//                   ),
//                 IconButton(
//                   icon: Icon(
//                     size: 30,
//                     note.isLiked(user!.uid)
//                         ? Icons.favorite
//                         : Icons.favorite_border,
//                     color: note.isLiked(user!.uid) ? Colors.red : Colors.grey,
//                   ),
//                   onPressed: () {
//                     Provider.of<NotesController>(context, listen: false)
//                         .toggleLike(user!.uid, note);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ✅ Function to Download File
//   Future<void> _downloadFile(String fileUrl) async {
//     Uri url = Uri.parse(fileUrl);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to open file')),
//       );
//     }
//   }
// }

