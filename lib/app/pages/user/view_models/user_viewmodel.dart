// user_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:poliglotim/app/authentication/repositories/auth_repository.dart';
import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/user.dart';
import 'package:poliglotim/app/data/models/progress.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository;
  final _log = Logger('UserViewModel');

  AuthViewModel({AuthRepository? authRepository})
      : _repository = authRepository ?? Get.find<AuthRepository>();

  // State
  User? _user;
  CourseProgress? progress;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  Future<Result<void>> loadUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getUserData();

    switch (result) {
      case Ok():
        _user = result.value;
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load user data: ${result.error}");
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Result<void>> loadUserProgress() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getUserData();

    switch (result) {
      case Ok():
        _user = result.value;
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load user data: ${result.error}");
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> refreshUserData() async {
    _error = null;
    notifyListeners();
    await loadUserData();
  }
}
