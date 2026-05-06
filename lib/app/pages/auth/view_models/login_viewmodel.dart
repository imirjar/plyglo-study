import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

import 'package:poliglotim/app/authentication/repositories/auth_repository.dart';
import 'package:poliglotim/app/core/result.dart';

class LoginViewModel {
  // LoginViewModel(this._repository, this._localStorage);

  LoginViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? Get.find<AuthRepository>() {
    login = LoginCommand(_login);
  }
  final AuthRepository _authRepository;
  final _log = Logger('LoginViewModel');

  late LoginCommand login;

  Future<Result<void>> _login() async {
    final result = await _authRepository.login();
    if (result is Error<void>) {
      _log.warning('Login failed! ${result.error}');
    }
    return result;
  }

  // final AuthRepository _repository;
  // final TokenStorage _localStorage;

  // bool _isAuthenticated = false;
  // bool _isLoading = false;
  // String? myToken;
  // String? _error;

  // bool get isAuthenticated => _isAuthenticated;
  // bool get isLoading => _isLoading;
  // String? get error => _error;

  // Future<void> login(String email, String password) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     // Здесь должна быть логика входа через API
  //     myToken = await _repository.login(email, password);
  //     // Предположим, что мы получили токен
  //     // const mockToken = 'your.jwt.token';
  //     // print(" TOOOOKEEEEN $myToken");

  //     await _localStorage.cacheToken(myToken!);
  //     _isAuthenticated = true;
  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //     _isAuthenticated = false;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> logout() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     await _localStorage.deleteCachedToken();
  //     _isAuthenticated = false;
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}

typedef _LoginAction = Future<Result<void>> Function();

class LoginCommand extends ChangeNotifier {
  LoginCommand(this._action);

  final _LoginAction _action;

  bool _running = false;
  Result<void>? _result;

  bool get running => _running;
  bool get completed => _result is Ok<void>;
  bool get hasError => _result is Error<void>;
  Result<void>? get result => _result;

  Future<void> execute() async {
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await _action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}
