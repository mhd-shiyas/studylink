class SubjectModel {
  String? semesterId;
  String? subjectId;
  final String? subjectName;

  SubjectModel({
    required this.semesterId,
    required this.subjectId,
    required this.subjectName,
  });

  factory SubjectModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return SubjectModel(
      semesterId: map["sem_id"],
      subjectId: id,
      subjectName: map['sub_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sem_id": semesterId,
      "sub_id": subjectId,
      "sub_name": subjectName,
    };
  }
}
