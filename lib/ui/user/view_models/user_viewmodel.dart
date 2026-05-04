// user_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:poliglotim/domain/models/user.dart';
import 'package:poliglotim/domain/models/progress.dart';
import 'package:poliglotim/data/repositories/auth/auth_repository.dart';
import 'package:poliglotim/utils/result.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository;
  final _log = Logger('UserViewModel');

  AuthViewModel({required AuthRepository userRepository}) 
    : _repository = userRepository;

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
    
    switch(result) {
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
    
    switch(result) {
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