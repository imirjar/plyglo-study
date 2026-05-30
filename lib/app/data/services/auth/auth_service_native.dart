import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:poliglotim/app/config/app_config.dart';
import 'package:poliglotim/app/data/models/token_model.dart';
import 'package:poliglotim/app/data/models/user.dart';

class AuthService {
  AuthService();

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _authBaseUrl = AppConfig.current.auth;
  final Logger _log = Logger('AuthServiceNative');

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _idTokenKey = 'id_token';
  static const _clientId = 'native';
  static const _nativeRedirectUrl = 'com.poliglotim.app:/callback';
  static const _scopes = [
    'openid',
    'profile',
    'email',
  ];

  String get _normalizedAuthBaseUrl => _authBaseUrl.endsWith('/')
      ? _authBaseUrl.substring(0, _authBaseUrl.length - 1)
      : _authBaseUrl;
  String get _userInfoEndpoint =>
      '$_normalizedAuthBaseUrl/protocol/openid-connect/userinfo';

  Future<bool> completePendingLogin() async => false;

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<String?> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return null;
    return 'Bearer $token';
  }

  Future<TokenModel?> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _nativeRedirectUrl,
          issuer: _normalizedAuthBaseUrl,
          scopes: _scopes,
          allowInsecureConnections: true,
        ),
      );

      return _storeTokenResult(result);
    } on Exception catch (error) {
      _log.warning('Login error', error);
      return null;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final result = await _appAuth.token(
        TokenRequest(
          _clientId,
          _nativeRedirectUrl,
          issuer: _normalizedAuthBaseUrl,
          refreshToken: refreshToken,
          scopes: _scopes,
          allowInsecureConnections: true,
        ),
      );

      return await _storeTokenResult(result) != null;
    } on Exception catch (error) {
      _log.warning('Refresh token error', error);
      await clearTokens();
      return false;
    }
  }

  Future<User> getUserData() async {
    final authHeader = await getAuthHeader();
    if (authHeader == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.get(
      Uri.parse(_userInfoEndpoint),
      headers: {
        'Accept': 'application/json',
        'Authorization': authHeader,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return User.fromKeycloakJson(json);
  }

  Future<void> logout() => _storage.deleteAll();

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _idTokenKey);
  }

  Future<TokenModel?> _storeTokenResult(dynamic result) async {
    final accessToken = result.accessToken;
    if (accessToken == null || accessToken.isEmpty) return null;

    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (result.refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: result.refreshToken);
    }
    if (result.idToken != null) {
      await _storage.write(key: _idTokenKey, value: result.idToken);
    }

    return TokenModel.fromOAuthResponse(
      accessToken: accessToken,
      refreshToken: result.refreshToken,
      accessTokenExpirationDateTime: result.accessTokenExpirationDateTime,
    );
  }
}
