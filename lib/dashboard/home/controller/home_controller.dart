import 'package:flutter/material.dart';
import 'package:studylink/dashboard/home/repository/home_repository.dart';

class HomeController with ChangeNotifier {
  final HomeRepository _userRepository = HomeRepository();

  List<Map<String, dynamic>> _departmentModel = [];
  List<Map<String, dynamic>>? get department => _departmentModel;

  bool _isLoading = false;
  bool get isloading => _isLoading;

  Future<void> fetchDepartment() async {
    _isLoading = true;
    notifyListeners();

    _departmentModel = await _userRepository.getDepartment();

    _isLoading = false;
    notifyListeners();
  }
}
