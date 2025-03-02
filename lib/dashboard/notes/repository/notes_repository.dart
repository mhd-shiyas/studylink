import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studylink/dashboard/notes/model/notes_model.dart';

class NotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Fetch notes filtered by subject & year
  Future<List<NotesModel>> fetchNotes(
      String subjectId, String selectedYear) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('modules')
          .where('subjectId', isEqualTo: subjectId)
          .get();

      return snapshot.docs
          .map((doc) =>
              NotesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching notes: $e");
      return [];
    }
  }

  /// ✅ Fetch student's selected year from Firestore
  Future<String?> fetchStudentYear(String studentId) async {
    try {
      DocumentSnapshot studentDoc =
          await _firestore.collection('users').doc(studentId).get();
      if (studentDoc.exists) {
        return studentDoc['yearOfAdmission'];
      }
    } catch (e) {
      print("Error fetching student year: $e");
    }
    return null;
  }

  // /// ✅ Fetch Notes (Already in Your Code)
  // Future<Map<String, List<NotesModel>>> fetchNotes(String subjectId) async {
  //   QuerySnapshot snapshot = await _firestore
  //       .collection('modules')
  //       .where('subjectId', isEqualTo: subjectId)
  //       .get();

  //   List<NotesModel> notes = [];
  //   List<NotesModel> pyqp = [];

  //   for (var doc in snapshot.docs) {
  //     NotesModel note = NotesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  //     if (note.noteType == "Notes") {
  //       notes.add(note);
  //     } else if (note.noteType == "PYQP") {
  //       pyqp.add(note);
  //     }
  //   }

  //   return {"Notes": notes, "PYQP": pyqp};
  // }

  /// ✅ Update Like Status in Firestore
  Future<void> updateLikedNote(
      String userId, String noteId, bool isLiked) async {
    DocumentReference moduleRef = _firestore.collection('modules').doc(noteId);
    DocumentReference likedRef = _firestore
        .collection('students')
        .doc(userId)
        .collection('likedNotes')
        .doc(noteId);

    if (isLiked) {
      // ❌ Unlike Note (Remove from Firestore)
      await moduleRef.update({
        'likes': FieldValue.arrayRemove([userId])
      });
      await likedRef.delete();
    } else {
      // ✅ Like Note (Add to Firestore)
      await moduleRef.update({
        'likes': FieldValue.arrayUnion([userId])
      });
      await likedRef.set({'moduleId': noteId});
    }
  }

  /// ✅ Fetch Liked Notes for a Specific User
  Future<List<NotesModel>> fetchLikedNotes(String userId) async {
    QuerySnapshot likedSnapshot = await _firestore
        .collection('students')
        .doc(userId)
        .collection('likedNotes')
        .get();

    List<String> likedModuleIds =
        likedSnapshot.docs.map((doc) => doc.id).toList();

    if (likedModuleIds.isEmpty) return [];

    QuerySnapshot modulesSnapshot = await _firestore
        .collection('modules')
        .where(FieldPath.documentId, whereIn: likedModuleIds)
        .get();

    return modulesSnapshot.docs
        .map((doc) =>
            NotesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
