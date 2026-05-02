import 'package:logging/logging.dart';
import 'package:poliglotim/domain/models/user.dart';

import '../../../utils/result.dart';
import 'user_repository.dart';

class UserRepositoryLocal extends UserRepository {
  UserRepositoryLocal();

  bool _isAuthenticated = false;
  final _log = Logger('UserRepositoryLocal');

  @override
  Future<bool> get isAuthenticated async => _isAuthenticated;

  @override
  Future<Result<void>> login() async {
    try {
      _isAuthenticated = true;
      _log.info('Local user logged in');
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      _isAuthenticated = false;
      _log.info('Local user logged out');
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
      return Result.ok(
        User(
            id: 'local-user',
            username: 'Local user',
            email: 'local@poliglotim.dev'),
      );
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }
}
