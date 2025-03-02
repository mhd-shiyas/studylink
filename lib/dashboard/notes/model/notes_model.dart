class NotesModel {
  String? noteId;
  final String? noteName;
  String? subjectId;
  final String? description;
  final String? noteType;
  final List<dynamic>? likes; // Stores student IDs who liked the note
  String? teacherId;
  final String? teacherName;
  final String? fileURL;
  final String? youtubeLink;

  NotesModel({
    required this.noteId,
    required this.noteName,
    required this.subjectId,
    required this.description,
    required this.noteType,
    required this.likes, // List of student IDs
    required this.teacherId,
    required this.teacherName,
    required this.fileURL,
    required this.youtubeLink,
  });

  // ✅ Compute isLiked dynamically instead of storing as boolean
  bool isLiked(String studentId) {
    return likes != null && likes!.contains(studentId);
  }

  factory NotesModel.fromMap(String id, Map<String, dynamic> map) {
    return NotesModel(
        noteId: id,
        noteName: map['title'] ?? '',
        subjectId: map['subjectId'] ?? '',
        description: map['description'] ?? '',
        noteType: map['fileType'] ?? '',
        likes: map['likes'] ?? [], // Firestore stores likes as a list
        teacherId: map['teacherId'] ?? '',
        teacherName: map['teacherName'] ?? '',
        fileURL: map["fileUrl"],
        youtubeLink: map["youtubeLink"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "moduleId": noteId,
      "title": noteName,
      "subjectId": subjectId,
      "description": description,
      "fileType": noteType,
      "likes": likes, // Store likes as list
      "teacherId": teacherId,
      "teacherName": teacherName,
      "fileUrl": fileURL,
      "youtubeLink": youtubeLink,
    };
  }
}

// class NotesModel {
//   String? noteId;
//   final String? noteName;
//   String? subjectId;
//   final String? description;
//   final String? noteType;
//   late final bool isLiked;
//   String? teacherId;
//   final String? teacherName;
//   final String? fileURL;

//   NotesModel({
//     required this.noteId,
//     required this.noteName,
//     required this.subjectId,
//     required this.description,
//     required this.noteType,
//     required this.isLiked,
//     required this.teacherId,
//     required this.teacherName,
//     required this.fileURL,
//   });

//   factory NotesModel.fromMap(
//     String id,
//     Map<String, dynamic> map,
//   ) {
//     return NotesModel(
//         noteId: id,
//         noteName: map['title'] ?? '',
//         subjectId: map['subjectId'] ?? '',
//         description: map['description'] ?? '',
//         noteType: map['fileType'] ?? '',
//         isLiked: map['is_Liked'] ?? false,
//         teacherId: map['teacherId'] ?? '',
//         teacherName: map['teacherName'] ?? '',
//         fileURL: map["fileUrl"]);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "moduleId": noteId,
//       "title": noteName,
//       "subjectId": subjectId,
//       "description": description,
//       "fileType": noteType,
//       "is_Liked": isLiked,
//       "teacherId": teacherId,
//       "teacherName": teacherName,
//       "fileUrl": fileURL
//     };
//   }
// }
