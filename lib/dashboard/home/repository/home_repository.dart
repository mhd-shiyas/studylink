import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getDepartment() async {
    try {
      final snapshot = await _firebaseFirestore.collection("departments").get();
      return snapshot.docs.map((value) => value.data()).toList();
    } catch (e) {
      print("Error fetching user: $e");
      throw Exception("Failed to fetch data");
    }
  }
}
