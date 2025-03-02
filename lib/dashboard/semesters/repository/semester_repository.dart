import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studylink/dashboard/semesters/model/semester_model.dart';

class SemesterRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<SemesterModel>> fetchSemesters(String departmentId,String year) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("semesters")
          .where("dep_id", isEqualTo: departmentId).where("year", isEqualTo: year)
          .get();

      print("control ${snapshot.docs}");

      List<SemesterModel> semester = snapshot.docs.map((doc) {
        return SemesterModel.fromMap(doc.id, doc.data());
      }).toList();
      print("controlllll $semester");
      return semester;

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
