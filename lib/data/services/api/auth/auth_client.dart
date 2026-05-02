import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:poliglotim/domain/models/user.dart';

class AuthService {
  AuthService();

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _clientId = 'frontend';
  static const String _redirectUrl = 'com.poliglotim.app:/oauthredirect';

  static const String _issuer = 'http://localhost:9080/realms/study';
  static const String _userInfoEndpoint =
      '$_issuer/protocol/openid-connect/userinfo';

  static const List<String> _scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: 'refresh_token');
  }

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return null;

    return 'Bearer $token';
  }

  Future<bool> login() async {
    final AuthorizationTokenResponse result;
    try {
      result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          scopes: _scopes,
        ),
      );
    } on Exception {
      return false;
    }

    final accessToken = result.accessToken;
    if (accessToken == null) return false;

    await _storage.write(key: 'access_token', value: accessToken);

    if (result.refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: result.refreshToken);
    }

    if (result.idToken != null) {
      await _storage.write(key: 'id_token', value: result.idToken);
    }

    return true;
  }

  Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    final TokenResponse result;
    try {
      result = await _appAuth.token(
        TokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          refreshToken: refreshToken,
          scopes: _scopes,
        ),
      );
    } on Exception {
      return false;
    }

    final accessToken = result.accessToken;
    if (accessToken == null) return false;

    await _storage.write(key: 'access_token', value: accessToken);

    if (result.refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: result.refreshToken);
    }

    return true;
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
    return User(
      id: json['sub'] as String? ?? '',
      username: json['preferred_username'] as String? ??
          json['name'] as String? ??
          '',
      email: json['email'] as String? ?? '',
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'id_token');
  }
}
