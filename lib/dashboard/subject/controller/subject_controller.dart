import 'package:flutter/material.dart';
import 'package:studylink/dashboard/subject/repository/subject_repository.dart';

import '../model/subject_model.dart';

class SubjectController with ChangeNotifier {
  final SubjectRepository _subjectRepository = SubjectRepository();

  List<SubjectModel>? _subjects = [];
  List<SubjectModel>? get subjects => _subjects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSemesters(String semesterId) async {
    _isLoading = true;
    notifyListeners();

    _subjects = await _subjectRepository.fetchSubjects(semesterId);

    _isLoading = false;
    notifyListeners();
  }
}
