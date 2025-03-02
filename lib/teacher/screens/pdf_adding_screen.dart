import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/constants/color_constants.dart';
import 'package:studylink/teacher/controllers/user_controller.dart';
import 'package:studylink/teacher/widgets/custom_button.dart';
import 'package:studylink/teacher/widgets/custom_textfield.dart';

import '../controllers/home_controller.dart';
import '../widgets/notes_type_widget.dart';

class PdfAddingScreen extends StatefulWidget {
  final String subjectId;
  const PdfAddingScreen({
    super.key,
    required this.subjectId,
  });

  @override
  _PdfAddingScreenState createState() => _PdfAddingScreenState();
}

class _PdfAddingScreenState extends State<PdfAddingScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<TeachersUserController>(context, listen: false)
        .fetchUser(user!.uid);
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();

  String? _fileName;
  Uint8List? _fileData;
  String? _selectedFileType;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.first.name;
        _fileData = result.files.first.bytes;
      });
      if (_fileData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to read file data. Try again!')),
        );
      }
    }
  }

//   Future<void> _uploadModule(TeachersHomeController controller) async {
//   if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please fill all required fields')),
//     );
//     return;
//   }

//   final authProvider = Provider.of<TeachersUserController>(context, listen: false);

//   // Ensure only one type of upload is selected
//   if ((_selectedFileType == 'YouTube Video Link' && _youtubeLinkController.text.isNotEmpty) &&
//       _fileData != null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please upload either a YouTube link OR a file, not both')),
//     );
//     return;
//   }

//   if (_selectedFileType == 'YouTube Video Link') {
//     // Validate YouTube Link
//     if (_youtubeLinkController.text.isEmpty || !_youtubeLinkController.text.contains('youtube.com')) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid YouTube link')),
//       );
//       return;
//     }

//     try {
//       await controller.uploadYouTubeLink(
//         teacherId: user!.uid,
//         teacherName: authProvider.user?.name ?? '',
//         title: _titleController.text,
//         description: _descriptionController.text,
//         youtubeLink: _youtubeLinkController.text, // Uploading only YouTube link
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('YouTube link uploaded successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading YouTube link: $e')),
//       );
//     }
//   } else {
//     // Handle File Upload (Notes or PYQP)
//     if (_fileData == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload a file')),
//       );
//       return;
//     }

//     try {
//       await controller.uploadFile(
//         teacherId: user!.uid,
//         teacherName: authProvider.user?.name ?? '',
//         title: _titleController.text,
//         description: _descriptionController.text,
//         subjectId: widget.subjectId,
//         fileData: _fileData!,
//         fileName: _fileName!,
//         // youtubeLink: youtubeLinkController.text,
//         fileType: _selectedFileType!,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('File uploaded successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading file: $e')),
//       );
//     }
//   }
// }

  Future<void> _uploadModule(TeachersHomeController controller) async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedFileType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a file')),
      );
      return;
    }
    final authProvider =
        Provider.of<TeachersUserController>(context, listen: false);

    try {
      _selectedFileType == "YT_Link"
          ? await controller.uploadYouTubeLink(
              teacherId: user!.uid,
              teacherName: authProvider.user?.name ?? '',
              title: _titleController.text,
              description: _descriptionController.text,
              subjectId: widget.subjectId,
              // fileData: _fileData!,
              // fileName: _fileName!,
              youtubeLink: youtubeLinkController.text,
              fileType: _selectedFileType!,
            )
          : await controller.uploadFile(
              teacherId: user!.uid,
              teacherName: authProvider.user?.name ?? '',
              title: _titleController.text,
              description: _descriptionController.text,
              subjectId: widget.subjectId,
              fileData: _fileData!,
              fileName: _fileName!,
              // youtubeLink: youtubeLinkController.text,
              fileType: _selectedFileType!,
            );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully')),
      );

      // Reset form
      _titleController.clear();
      _descriptionController.clear();
      youtubeLinkController.clear();
      setState(() {
        _fileName = null;
        _fileData = null;
        _selectedFileType = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TeachersHomeController>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Uplaod",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Notes',
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              CustomTextfield(
                hint: "Title",
                controller: _titleController,
              ),
              // TextField(
              //   controller: _titleController,
              //   decoration: const InputDecoration(
              //     labelText: 'Title',
              //     border: OutlineInputBorder(),
              //   ),
              // ),

              CustomTextfield(
                hint: "Description",
                controller: _descriptionController,
                maxLines: 3,
              ),
              // TextField(
              //   controller: _descriptionController,
              //   decoration: const InputDecoration(
              //     labelText: 'Description',
              //     border: OutlineInputBorder(),
              //   ),
              //   maxLines: 3,
              // ),
              SizedBox(
                height: 16,
              ),
              const Text(
                'Select File Type:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  NotesTypeWidget(
                    title: 'Notes',
                    value: _selectedFileType == 'Notes',
                    onChanged: (value) {
                      setState(() {
                        _selectedFileType = value! ? 'Notes' : null;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  NotesTypeWidget(
                    title: 'Previous Year Question Papers (PYQP)',
                    value: _selectedFileType == 'PYQP',
                    onChanged: (value) {
                      setState(() {
                        _selectedFileType = value! ? 'PYQP' : null;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  NotesTypeWidget(
                    title: 'YouTube Video Link',
                    value: _selectedFileType == 'YT_Link',
                    onChanged: (value) {
                      setState(() {
                        _selectedFileType = value! ? 'YT_Link' : null;
                      });
                    },
                  ),
                ],
              ),

              if (_selectedFileType == "YT_Link")
                CustomTextfield(
                  hint: "Give Youtube Link Here",
                  controller: youtubeLinkController,
                ),
              if (_selectedFileType == "Notes" || _selectedFileType == "PYQP")
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_rounded),
                            SizedBox(
                              width: 6,
                            ),
                            CustomButton(
                              title: _fileName == null
                                  ? "Upload Pdf/File"
                                  : "Uploaded",
                              bgColor: Colors.transparent,
                              textColor: ColorConstants.primaryColor,
                              onTap: _selectFile,
                            ),
                          ],
                        )),
                    const SizedBox(width: 10),
                    if (_fileName != null)
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(child: Text(_fileName!))),
                    // ElevatedButton(
                    //   onPressed: _selectFile,
                    //   child: const Text('Select File'),
                    // ),
                  ],
                ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: ColorConstants.primaryColor,
                        ))
                      : controller.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.primaryColor,
                              ),
                            )
                          : CustomButton(
                              title: "Upload",
                              onTap: () => _uploadModule(controller),
                            )),
              // controller.isLoading
              //     ? const Center(child: CircularProgressIndicator())
              //     : ElevatedButton(
              //         onPressed: () => _uploadModule(controller),
              //         child: const Text('Upload'),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
