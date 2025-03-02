import 'package:flutter/material.dart';
import 'package:studylink/auth/model/user_model.dart';
import 'package:studylink/auth/repository/user_repository.dart';

class UserController with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isloading => _isLoading;

  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    _user = await _userRepository.getUserById(userId);
    print(userId);

    _isLoading = false;
    notifyListeners();
  }
}
