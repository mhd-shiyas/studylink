import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studylink/teacher/models/notes_model.dart';

import '../models/semester_model.dart';
import '../models/subject_model.dart';
import '../repositories/home_repository.dart';

class TeachersHomeController extends ChangeNotifier {
  bool isLoading = false;

  final HomeRepository _homeRepository = HomeRepository();

  List<Map<String, dynamic>> _departmentModel = [];
  List<Map<String, dynamic>>? get department => _departmentModel;

  bool _isLoading = false;
  bool get isDepartmentLoading => _isLoading;

  Future<void> fetchDepartment() async {
    _isLoading = true;
    notifyListeners();

    _departmentModel = await _homeRepository.getDepartment();

    _isLoading = false;
    notifyListeners();
  }

  List<SemesterModel>? _semesters = [];
  List<SemesterModel>? get semesters => _semesters;

  bool _semesterisLoading = false;
  bool get isSemesterLoading => _semesterisLoading;

  Future<void> fetchSemesters(String year) async {
    _semesterisLoading = true;
    notifyListeners();

    _semesters = await _homeRepository.fetchSemesters(year);

    _semesterisLoading = false;
    notifyListeners();
  }

  List<SubjectModel>? _subjects = [];
  List<SubjectModel>? get subjects => _subjects;

  bool _isSubjectLoading = false;
  bool get isSubjectLoading => _isSubjectLoading;

  Future<void> fetchSubject(String semesterId) async {
    _isSubjectLoading = true;
    notifyListeners();

    _subjects = await _homeRepository.fetchSubjects(semesterId);

    _isSubjectLoading = false;
    notifyListeners();
  }

  // Future<List<Map<String, dynamic>>> fetchSubjects() async {
  //   try {
  //     QuerySnapshot snapshot =
  //         await FirebaseFirestore.instance.collection('subjects').get();

  //     return snapshot.docs
  //         .map((doc) => {
  //               'id': doc.id,
  //               'name': doc['name'],
  //             })
  //         .toList();
  //   } catch (e) {
  //     throw Exception('Failed to fetch subjects: $e');
  //   }
  // }

  Future<List<NotesModel>> fetchTeacherNotes(String teacherId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('modules')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      return snapshot.docs
          .map((doc) =>
              NotesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching teacher's notes: $e");
      return [];
    }
  }

  Future<void> deleteNote(NotesModel note) async {
    try {
      // ✅ Delete from Firestore
      await FirebaseFirestore.instance
          .collection('modules')
          .doc(note.noteId)
          .delete();

      // ✅ Delete from Firebase Storage
      if (note.fileUrl != null && note.fileUrl!.isNotEmpty) {
        Reference storageRef =
            FirebaseStorage.instance.refFromURL(note.fileUrl!);
        await storageRef.delete();
      }

      notifyListeners();
    } catch (e) {
      print("Error deleting note: $e");
      rethrow;
    }
  }

  Future<void> uploadFile({
    required String teacherId,
    required String teacherName,
    required String title,
    required String description,
    required String subjectId,
    required Uint8List fileData,
    required String fileName,
    required String fileType,
    // required String youtubeLink,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Generate a unique moduleId
      String moduleId =
          FirebaseFirestore.instance.collection('modules').doc().id;

      // Upload file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads')
          .child(teacherId)
          .child(moduleId)
          .child(fileName);

      await storageRef.putData(fileData);
      String fileUrl = await storageRef.getDownloadURL();

      // Save metadata to Firestore
      await FirebaseFirestore.instance.collection('modules').doc(moduleId).set({
        'moduleId': moduleId,
        'teacherId': teacherId,
        'teacherName': teacherName,
        'title': title,
        'description': description,
        'subjectId': subjectId,
        'fileUrl': fileUrl,
        "fileType": fileType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadYouTubeLink({
    required String teacherId,
    required String teacherName,
    required String title,
    required String description,
    required String subjectId,
    required String youtubeLink,
    required String fileType,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Generate a unique moduleId
      String moduleId =
          FirebaseFirestore.instance.collection('modules').doc().id;

      // Save metadata to Firestore (without file upload)
      await FirebaseFirestore.instance.collection('modules').doc(moduleId).set({
        'moduleId': moduleId,
        'teacherId': teacherId,
        'teacherName': teacherName,
        'title': title,
        'description': description,
        'subjectId': subjectId,
        'fileType': fileType,
        'youtubeLink': youtubeLink,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload YouTube link: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
