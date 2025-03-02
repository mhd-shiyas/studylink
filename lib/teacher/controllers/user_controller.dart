import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class TeachersUserController with ChangeNotifier {
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

  Future<bool> checkUserStatus(String id) async {
    return await _userRepository.checkUserStatus(id);
  }
}
