import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/subject_model.dart';

class SubjectRepository {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<List<SubjectModel>> fetchSubjects(String semesterId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("subjects")
          .where("sem_id", isEqualTo: semesterId)
          .get();

      List<SubjectModel> subjects = snapshot.docs.map((doc) {
        return SubjectModel.fromMap(doc.id, doc.data());
      }).toList();

      return subjects;

      // if (snapshot.exists) {
      //   return SemesterModel.fromMap(
      //       snapshot.id, snapshot.data() as Map<String, dynamic>);
      // } else {
      //   print("Semester not found");
      //   return null;
      // }

      // final snapshot = await _firebaseFirestore
      //     .collection('semesters')
      //     .where('dep_id', isEqualTo: departmentId)
      //     .get();
      // return snapshot.docs
      //     .map((doc) => doc.data() as Map<String, dynamic>)
      //     .toList();
    } catch (e) {
      print('Error fetching semesters: $e');
      throw Exception('Failed to fetch semesters');
    }
  }

}