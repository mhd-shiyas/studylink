import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink/dashboard/home/screens/home_screen.dart';
import 'package:studylink/dashboard/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/color_constants.dart';
import '../../notes/controller/notes_controller.dart';
import '../../notes/model/notes_model.dart';
import '../../profile/screens/profile_screen.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({super.key});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final user = FirebaseAuth.instance.currentUser;

  List<NotesModel> _likedNotes = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchLikedModules();
  }

  Future<void> _fetchLikedModules() async {
    try {
      final likedNotes =
          await Provider.of<NotesController>(context, listen: false)
              .fetchLikedNotes(user!.uid);

      setState(() {
        _likedNotes = likedNotes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching liked notes: $e')),
      );
    }
  }

  void _unlikeNote(NotesModel note) {
    Provider.of<NotesController>(context, listen: false)
        .toggleLike(user!.uid, note);

    setState(() {
      _likedNotes.removeWhere((item) => item.noteId == note.noteId);
    });
  }

  /// ✅ Function to Download File
  Future<void> _downloadFile(String fileUrl) async {
    Uri url = Uri.parse(fileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Liked"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _likedNotes.isEmpty
              ? const Center(child: Text('No liked notes'))
              : ListView.builder(
                  itemCount: _likedNotes.length,
                  itemBuilder: (context, index) {
                    final note = _likedNotes[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.noteName ?? "Untitled",
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              note.description ?? "No Description",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Uploaded by: ${note.teacherName}",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Type: ${note.noteType}",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _downloadFile(note.fileURL!),
                                    icon: const Icon(
                                      Icons.download,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: Text("Download",
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          ColorConstants.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite,
                                      color: Colors.red),
                                  onPressed: () {
                                    _unlikeNote(note);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(4.0).copyWith(bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: ColorConstants.secondaryColor.withOpacity(0.3),
                width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BottomNavigationBar(
              elevation: 10,
              unselectedItemColor: Colors.black38,
              selectedItemColor: ColorConstants.primaryColor,
              unselectedLabelStyle: GoogleFonts.inter(),
              selectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
              ),
              showUnselectedLabels: false,
              showSelectedLabels: false,
              currentIndex: 0,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/house.svg",
                    color: ColorConstants.primaryColor,
                    height: 25,
                    width: 25,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/heart-fill.svg",
                          color: ColorConstants.primaryColor,
                          height: 25,
                          width: 25,
                        ),
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstants.primaryColor,
                          ),
                        )
                      ],
                    ),
                    label: 'Like'),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/user.svg",
                      height: 25,
                      width: 25,
                    ),
                    label: 'Profile'),
              ],
              onTap: (index) {
                switch (index) {
                  case 0: // Home
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                    break;
                  case 1: // Like
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LikedScreen(),
                    //   ),
                    // );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user!.uid),
                      ),
                    );
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Build Sections for Notes & PYQP
  Widget _buildSection(String title, List<NotesModel> notes) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return _buildNoteItem(notes[index]);
        },
      ),
    );
  }

  /// ✅ Build Each Note Item with Like Button
  Widget _buildNoteItem(NotesModel note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(height: 5),
            Text(
              "Uploaded by: ${note.teacherName}",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadFile(note.fileURL!),
                    icon: const Icon(
                      Icons.download,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text("Download",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor: Colors.white,
                      backgroundColor: ColorConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () => _downloadFile(note.fileURL!),
                //   child: const Text("Download"),
                // ),
                IconButton(
                  icon: Icon(
                    size: 30,
                    note.isLiked(user!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: note.isLiked(user!.uid) ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    Provider.of<NotesController>(context, listen: false)
                        .toggleLike(user!.uid, note);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
