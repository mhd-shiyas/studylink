import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/teacher/constants/color_constants.dart';
import 'package:studylink/teacher/controllers/home_controller.dart';

import '../models/notes_model.dart';

class UploadedNotesScreen extends StatefulWidget {
  final String teacherId; // Logged-in teacher's ID

  const UploadedNotesScreen({super.key, required this.teacherId});

  @override
  _UploadedNotesScreenState createState() => _UploadedNotesScreenState();
}

class _UploadedNotesScreenState extends State<UploadedNotesScreen> {
  bool _isLoading = true;
  List<NotesModel> _uploadedNotes = [];

  @override
  void initState() {
    super.initState();
    _fetchUploadedNotes();
  }

  /// ✅ Fetch Notes Uploaded by This Teacher
  Future<void> _fetchUploadedNotes() async {
    try {
      final notesController =
          Provider.of<TeachersHomeController>(context, listen: false);
      final notes = await notesController.fetchTeacherNotes(widget.teacherId);

      setState(() {
        _uploadedNotes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching notes: $e')),
      );
    }
  }

  /// ✅ Delete Note from Firestore & Storage
  Future<void> _deleteNote(NotesModel note) async {
    try {
      await Provider.of<TeachersHomeController>(context, listen: false)
          .deleteNote(note);

      setState(() {
        _uploadedNotes.removeWhere((item) => item.noteId == note.noteId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Your Uploaded Notes',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ColorConstants.primaryColor,
        ),
      )),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _uploadedNotes.isEmpty
              ? const Center(child: Text('No uploaded notes found'))
              : ListView.builder(
                  itemCount: _uploadedNotes.length,
                  itemBuilder: (context, index) {
                    final note = _uploadedNotes[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title ?? "Untitled",
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              note.description ?? "No Description",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Type: ${note.fileType}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteNote(note),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
