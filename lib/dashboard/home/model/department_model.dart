
class DepartmentModel {
  String? deparmentid;
  final String? departmentName;

  DepartmentModel({
    required this.deparmentid,
    required this.departmentName,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentModel(
      deparmentid: id,
      departmentName: map['dep_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "dep_id": deparmentid,
      "dep_name": departmentName,
    };
  }
}
