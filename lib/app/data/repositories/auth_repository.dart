import 'package:flutter/foundation.dart';
import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/user.dart';
import 'package:poliglotim/app/data/services/auth/auth_service.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;
  bool _isAuthenticated = false;

  bool get isAuthenticatedSync => _isAuthenticated;

  Future<bool> get isAuthenticated async {
    _isAuthenticated = await _authService.hasAccessToken();
    return _isAuthenticated;
  }

  Future<void> initialize() async {
    await _authService.completePendingLogin();
    _isAuthenticated = await _authService.hasAccessToken();
    notifyListeners();
  }

  Future<Result<void>> login() async {
    try {
      final token = await _authService.login();
      _isAuthenticated = token != null || await _authService.hasAccessToken();
      notifyListeners();

      if (_isAuthenticated) return const Result.ok(null);
      return Result.error(Exception('Login was not completed'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _authService.logout();
      _isAuthenticated = false;
      notifyListeners();
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<User>> getUserData() async {
    try {
      return Result.ok(await _authService.getUserData());
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
