import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.collection('teachers').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      }
      print("repost $userId");
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }
}
