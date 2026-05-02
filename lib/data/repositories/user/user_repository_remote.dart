import 'package:logging/logging.dart';
import 'package:poliglotim/data/services/api/auth/auth_client.dart';
import 'package:poliglotim/domain/models/user.dart';

import '../../../utils/result.dart';
import 'user_repository.dart';

class UserRepositoryRemote extends UserRepository {
  UserRepositoryRemote({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  bool? _isAuthenticated;
  final _log = Logger('UserRepositoryRemote');

  @override
  Future<bool> get isAuthenticated async {
    _isAuthenticated ??= await _authService.hasAccessToken();
    return _isAuthenticated!;
  }

  @override
  Future<Result<void>> login() async {
    try {
      final success = await _authService.login();
      _isAuthenticated = success;

      if (!success) {
        return Result.error(Exception('Login cancelled or failed'));
      }

      _log.info('User logged in');
      return const Result.ok(null);
    } on Exception catch (error) {
      _isAuthenticated = false;
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authService.logout();
      _isAuthenticated = false;
      _log.info('User logged out');
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<User>> getUserData() async {
    try {
      return Result.ok(await _authService.getUserData());
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }
}
