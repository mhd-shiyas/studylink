import 'package:flutter/material.dart';
import 'package:studylink/dashboard/semesters/model/semester_model.dart';
import 'package:studylink/dashboard/semesters/repository/semester_repository.dart';

class SemesterController with ChangeNotifier {
  final SemesterRepository _semesterRepository = SemesterRepository();

  List<SemesterModel>? _semesters = [];
  List<SemesterModel>? get semesters => _semesters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSemesters(String departmentId, String year) async {
    _isLoading = true;
    notifyListeners();

    _semesters = await _semesterRepository.fetchSemesters(departmentId, year);
    print("this is $_semesters");

    _isLoading = false;
    notifyListeners();
  }
}
