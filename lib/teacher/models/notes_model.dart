import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? noteId;
  final String? title;
  final String? description;
  final String? fileType;
  final String? fileUrl;
  final List<dynamic>? likes; // List of student IDs who liked this note
  final String? subjectId;
  final String? teacherId;
  final String? teacherName;
  final DateTime? timestamp;

  NotesModel({
    required this.noteId,
    required this.title,
    required this.description,
    required this.fileType,
    required this.fileUrl,
    required this.likes,
    required this.subjectId,
    required this.teacherId,
    required this.teacherName,
    required this.timestamp,
  });

  /// ✅ Compute if note is liked by the student
  bool isLiked(String studentId) {
    return likes != null && likes!.contains(studentId);
  }

  /// ✅ Create a `NotesModel` from Firestore data
  factory NotesModel.fromMap(String id, Map<String, dynamic> map) {
    return NotesModel(
      noteId: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      fileType: map['fileType'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      likes: map['likes'] ?? [], // Ensure likes is a list
      subjectId: map['subjectId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(), // Convert Firestore timestamp
    );
  }

  /// ✅ Convert `NotesModel` to Firestore format
  Map<String, dynamic> toMap() {
    return {
      "moduleId": noteId,
      "title": title,
      "description": description,
      "fileType": fileType,
      "fileUrl": fileUrl,
      "likes": likes, // Store likes as a list
      "subjectId": subjectId,
      "teacherId": teacherId,
      "teacherName": teacherName,
      "timestamp": timestamp, // Firestore handles timestamp conversion
    };
  }
}
