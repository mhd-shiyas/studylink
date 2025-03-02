class UserModel {
  String? uid;
  final String? name;
   String? email;
  String? phoneNumber;
  final String? department;
  final bool approval;
  // final String? yearOfAdmission;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.department,
    required this.approval,
    // required this.yearOfAdmission,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
        uid: id,
        name: map['name'] ?? '',
        email: map["email"] ?? '',
        phoneNumber: map["phoneNumber"] ?? '',
        department: map["department"] ?? '',
        approval: map["approvel"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "department": department,
      "approvel": approval
    };
  }
}
