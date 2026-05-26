// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:poliglotim/app/config/app_config.dart';
import 'package:poliglotim/app/data/models/token_model.dart';
import 'package:poliglotim/app/data/models/user.dart';

class AuthService {
  AuthService();

  final String _authBaseUrl = AppConfig.current.auth;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _idTokenKey = 'id_token';
  static const _codeVerifierKey = 'pkce_code_verifier';
  static const _stateKey = 'oauth_state';
  static const _returnUrlKey = 'oauth_return_url';
  static const _clientId = 'frontend';
  static const _scopes = [
    'openid',
    'profile',
    'email',
  ];

  String get _redirectUrl => '${html.window.location.origin}/auth/callback';
  String get _normalizedAuthBaseUrl => _authBaseUrl.endsWith('/')
      ? _authBaseUrl.substring(0, _authBaseUrl.length - 1)
      : _authBaseUrl;
  String get _authorizeEndpoint =>
      '$_normalizedAuthBaseUrl/protocol/openid-connect/auth';
  String get _tokenEndpoint =>
      '$_normalizedAuthBaseUrl/protocol/openid-connect/token';
  String get _userInfoEndpoint =>
      '$_normalizedAuthBaseUrl/protocol/openid-connect/userinfo';

  Future<bool> completePendingLogin() async {
    final uri = Uri.parse(html.window.location.href);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];

    if (code == null || state == null) return false;

    final expectedState = html.window.localStorage[_stateKey];
    final codeVerifier = html.window.localStorage[_codeVerifierKey];
    final returnUrl = _safeReturnUrl(html.window.localStorage[_returnUrlKey]);

    if (expectedState == null ||
        codeVerifier == null ||
        expectedState != state) {
      html.window.console.warn(
        'OAuth callback state mismatch or missing PKCE verifier.',
      );
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

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAccessToken() async =>
      html.window.localStorage[_accessTokenKey];

  Future<String?> getRefreshToken() async =>
      html.window.localStorage[_refreshTokenKey];

  Future<String?> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return null;
    return 'Bearer $token';
  }

  Future<TokenModel?> login() async {
    final uri = Uri.parse(html.window.location.href);
    if (uri.queryParameters.containsKey('code')) {
      final completed = await completePendingLogin();
      return completed
          ? TokenModel.fromStoredAccessToken(await getAccessToken())
          : null;
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
    return null;
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

      if (response.statusCode != 200) {
        html.window.console.warn(
          'Refresh token failed: ${response.statusCode} ${response.body}',
        );
        await clearTokens();
        return false;
      }

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
    return User.fromKeycloakJson(json);
  }

  Future<void> logout() async {
    await clearTokens();
    await _clearPendingLogin();
  }

  Future<void> clearTokens() async {
    html.window.localStorage.remove(_accessTokenKey);
    html.window.localStorage.remove(_refreshTokenKey);
    html.window.localStorage.remove(_idTokenKey);
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

      if (response.statusCode != 200) {
        html.window.console.warn(
          'Authorization code exchange failed: '
          '${response.statusCode} ${response.body}',
        );
        return false;
      }

      await _storeTokenResponse(response.body);
      return true;
    } on Exception catch (error) {
      html.window.console.warn('Authorization code exchange error: $error');
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
    if (uri.path == '/auth/callback' || uri.path == '/login') {
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
