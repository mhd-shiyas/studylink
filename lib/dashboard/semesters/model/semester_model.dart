class SemesterModel {
  String? deparmentid;
  final String? semesterName;
  String? semesterId;

  SemesterModel(
      {required this.deparmentid,
      required this.semesterName,
      required this.semesterId});

  factory SemesterModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return SemesterModel(
      deparmentid: id,
      semesterId: map["sem_id"] ?? '',
      semesterName: map['sem_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "dep_id": deparmentid,
      "sem_name": semesterName,
      "sem_id": semesterId
    };
  }
}
