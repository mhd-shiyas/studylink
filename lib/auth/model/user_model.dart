class UserModel {
  String? uid;
  final String? name;
  String? email;
  String? phoneNumber;
  final String? course;
  final String? yearOfAdmission;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.course,
    required this.yearOfAdmission,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map["email"] ?? '',
      phoneNumber: map["phoneNumber"] ?? '',
      course: map["course"] ?? '',
      yearOfAdmission: map["yearOfAdmission"] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "course": course,
      "yearOfAdmission": yearOfAdmission,
    };
  }
}
