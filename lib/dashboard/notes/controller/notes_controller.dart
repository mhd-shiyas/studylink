
import 'package:flutter/material.dart';
import 'package:studylink/dashboard/notes/model/notes_model.dart';
import '../repository/notes_repository.dart';

class NotesController with ChangeNotifier {
  final NotesRepository _notesRepository = NotesRepository();

  List<NotesModel> _notes = [];
  List<NotesModel> _pyqp = [];
  List<NotesModel> _ytNotes = [];

  List<NotesModel> get notes => _notes;
  List<NotesModel> get pyqp => _pyqp;
  List<NotesModel> get ytNotes => _ytNotes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes(String subjectId, String studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the student's academic year
      String? selectedYear = await _notesRepository.fetchStudentYear(studentId);

      if (selectedYear != null) {
        // Fetch notes based on subject and year
        List<NotesModel> allNotes =
            await _notesRepository.fetchNotes(subjectId, selectedYear);

        // Categorize notes into Notes, PYQP, and YouTube Links
        _notes = allNotes.where((note) => note.noteType == "Notes").toList();
        _pyqp = allNotes.where((note) => note.noteType == "PYQP").toList();
        _ytNotes =
            allNotes.where((note) => note.noteType == "YT_Link").toList();
      }
      print("notes = $notes");
      print("pyqp = $pyqp");
      print("ytlink = $ytNotes");
    } catch (e) {
      print("Error fetching notes: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Fetch notes based on student's year
  // Future<void> fetchNotes(String subjectId, String studentId) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     String? selectedYear = await _notesRepository.fetchStudentYear(studentId);

  //     if (selectedYear != null) {
  //       _notes = await _notesRepository.fetchNotes(subjectId, selectedYear);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> fetchNotes(String subjectId) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     final result = await _notesRepository.fetchNotes(subjectId);
  //     _notes = result["Notes"] ?? [];
  //     _pyqp = result["PYQP"] ?? [];
  //   } catch (e) {
  //     print("Error: $e");
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  /// ✅ Toggle Like Function
  Future<void> toggleLike(String userId, NotesModel note) async {
    bool isCurrentlyLiked = note.isLiked(userId); // Check if user already liked

    try {
      // ✅ Update Firestore first
      await _notesRepository.updateLikedNote(
          userId, note.noteId!, isCurrentlyLiked);

      // ✅ Update the local list immediately
      for (var module in _notes) {
        if (module.noteId == note.noteId) {
          if (isCurrentlyLiked) {
            module.likes!.remove(userId);
          } else {
            module.likes!.add(userId);
          }
          break;
        }
      }

      for (var module in _pyqp) {
        if (module.noteId == note.noteId) {
          if (isCurrentlyLiked) {
            module.likes!.remove(userId);
          } else {
            module.likes!.add(userId);
          }
          break;
        }
      }

      for (var module in _ytNotes) {
        if (module.noteId == note.noteId) {
          if (isCurrentlyLiked) {
            module.likes!.remove(userId);
          } else {
            module.likes!.add(userId);
          }
          break;
        }
      }

      notifyListeners(); // ✅ Notify UI to update immediately
    } catch (e) {
      print("Error updating like: $e");
    }
  }

  /// ✅ Fetch Liked Notes for Liked Screen
  Future<List<NotesModel>> fetchLikedNotes(String userId) async {
    return await _notesRepository.fetchLikedNotes(userId);
  }
}
