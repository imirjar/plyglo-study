import 'package:logging/logging.dart';
import 'package:poliglotim/data/services/api/auth/auth_client.dart';
import 'package:poliglotim/domain/models/user.dart';

import '../../../utils/result.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  bool? _isAuthenticated;
  final _log = Logger('AuthRepositoryRemote'); // Исправлено имя логгера

  @override
  Future<bool> get isAuthenticated async {
    // Актуальное значение каждый раз, а не только при первом вызове
    _isAuthenticated = await _authService.hasAccessToken();
    return _isAuthenticated!;
  }

  @override
  Future<Result<void>> login() async {
    try {
      final success = await _authService.login();
      _isAuthenticated = success;

      if (!success) {
        _log.warning('Login cancelled or failed');
        return Result.error(Exception('Login cancelled or failed'));
      }

      _log.info('User logged in successfully');
      return const Result.ok(null);
    } on Exception catch (error) {
      _isAuthenticated = false;
      _log.severe('Login error', error);
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
      _log.info('User logged out successfully');
      return const Result.ok(null);
    } on Exception catch (error) {
      _log.severe('Logout error', error);
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<User>> getUserData() async {
    // Проверяем аутентификацию перед запросом
    if (!await isAuthenticated) {
      _log.warning('Attempted to get user data while not authenticated');
      return Result.error(Exception('User is not authenticated'));
    }

    try {
      final user = await _authService.getUserData();
      _log.info('User data loaded for: ${user.username}');
      return Result.ok(user);
    } on Exception catch (error) {
      _log.severe('Failed to load user data', error);
      
      // Если ошибка 401 - токен возможно истёк
      if (error.toString().contains('401')) {
        _isAuthenticated = false;
        notifyListeners();
      }
      
      return Result.error(error);
    }
  }
  
  // Дополнительный полезный метод
  Future<Result<void>> refreshToken() async {
    try {
      final success = await _authService.refreshToken();
      if (success) {
        _isAuthenticated = true;
        _log.info('Token refreshed successfully');
        return const Result.ok(null);
      } else {
        _isAuthenticated = false;
        _log.warning('Token refresh failed');
        return Result.error(Exception('Token refresh failed'));
      }
    } on Exception catch (error) {
      _isAuthenticated = false;
      _log.severe('Token refresh error', error);
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }
}
