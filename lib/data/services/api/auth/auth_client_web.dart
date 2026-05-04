// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:poliglotim/domain/models/user.dart';

class AuthService {
  AuthService();

  static const String _clientId = 'frontend';
  static const String _issuer = 'http://localhost:9080/realms/study';
  static const String _authorizeEndpoint =
      '$_issuer/protocol/openid-connect/auth';
  static const String _tokenEndpoint = '$_issuer/protocol/openid-connect/token';
  static const String _userInfoEndpoint =
      '$_issuer/protocol/openid-connect/userinfo';

  static const List<String> _scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _idTokenKey = 'id_token';
  static const String _codeVerifierKey = 'pkce_code_verifier';
  static const String _stateKey = 'oauth_state';
  static const String _returnUrlKey = 'oauth_return_url';

  String get _redirectUrl => '${html.window.location.origin}/auth/callback';

  Future<bool> completePendingLogin() async {
    final uri = Uri.parse(html.window.location.href);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];

    if (code == null || state == null) {
      return false;
    }

    final expectedState = html.window.localStorage[_stateKey];
    final codeVerifier = html.window.localStorage[_codeVerifierKey];
    final returnUrl = _safeReturnUrl(html.window.localStorage[_returnUrlKey]);

    if (expectedState == null ||
        codeVerifier == null ||
        expectedState != state) {
      await _clearPendingLogin();
      html.window.location.replace(returnUrl);
      return false;
    }

    final success = await _exchangeCode(
      code: code,
      codeVerifier: codeVerifier,
    );

    await _clearPendingLogin();

    html.window.location.replace(returnUrl);
    return success;
  }

  Future<String?> getAccessToken() async {
    return html.window.localStorage[_accessTokenKey];
  }

  Future<String?> getRefreshToken() async {
    return html.window.localStorage[_refreshTokenKey];
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
    final uri = Uri.parse(html.window.location.href);
    if (uri.queryParameters.containsKey('code')) {
      return completePendingLogin();
    }

    final codeVerifier = _randomUrlSafeString(64);
    final state = _randomUrlSafeString(32);
    final codeChallenge = _codeChallenge(codeVerifier);

    html.window.localStorage[_codeVerifierKey] = codeVerifier;
    html.window.localStorage[_stateKey] = state;
    html.window.localStorage[_returnUrlKey] = html.window.location.href;

    final authorizationUrl = Uri.parse(_authorizeEndpoint).replace(
      queryParameters: {
        'client_id': _clientId,
        'redirect_uri': _redirectUrl,
        'response_type': 'code',
        'scope': _scopes.join(' '),
        'state': state,
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      },
    );

    html.window.location.assign(authorizationUrl.toString());
    return false;
  }

  Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode != 200) return false;

      await _storeTokenResponse(response.body);
      return true;
    } on Exception {
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
    return User(
      id: json['sub'] as String? ?? '',
      username: json['preferred_username'] as String? ??
          json['name'] as String? ??
          '',
      email: json['email'] as String? ?? '',
    );
  }

  Future<void> logout() async {
    html.window.localStorage.remove(_accessTokenKey);
    html.window.localStorage.remove(_refreshTokenKey);
    html.window.localStorage.remove(_idTokenKey);
    await _clearPendingLogin();
  }

  Future<bool> _exchangeCode({
    required String code,
    required String codeVerifier,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'code': code,
          'redirect_uri': _redirectUrl,
          'code_verifier': codeVerifier,
        },
      );

      if (response.statusCode != 200) return false;

      await _storeTokenResponse(response.body);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<void> _storeTokenResponse(String body) async {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final accessToken = json['access_token'] as String?;
    final refreshToken = json['refresh_token'] as String?;
    final idToken = json['id_token'] as String?;

    if (accessToken != null) {
      html.window.localStorage[_accessTokenKey] = accessToken;
    }
    if (refreshToken != null) {
      html.window.localStorage[_refreshTokenKey] = refreshToken;
    }
    if (idToken != null) {
      html.window.localStorage[_idTokenKey] = idToken;
    }
  }

  Future<void> _clearPendingLogin() async {
    html.window.localStorage.remove(_codeVerifierKey);
    html.window.localStorage.remove(_stateKey);
    html.window.localStorage.remove(_returnUrlKey);
  }

  String _safeReturnUrl(String? storedReturnUrl) {
    final fallback = '${html.window.location.origin}/';
    if (storedReturnUrl == null || storedReturnUrl.isEmpty) return fallback;

    final uri = Uri.tryParse(storedReturnUrl);
    if (uri == null || uri.origin != html.window.location.origin) {
      return fallback;
    }

    if (uri.path == '/auth/callback') {
      return fallback;
    }

    return storedReturnUrl;
  }

  String _codeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  String _randomUrlSafeString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
