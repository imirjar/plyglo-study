// ignore_for_file: prefer_initializing_formals, use_null_aware_elements

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poliglotim/app/config/app_config.dart';
import 'package:poliglotim/app/data/services/auth/auth_service.dart';

class ApiService {
  ApiService({
    AuthService? authService,
    String? baseUrl,
    http.Client? httpClient,
    Future<void> Function()? onUnauthorized,
  })  : _authService = authService ?? AuthService(),
        _baseUrl = baseUrl ?? AppConfig.current.api,
        _httpClient = httpClient ?? http.Client(),
        _onUnauthorized = onUnauthorized;

  final AuthService _authService;
  final String _baseUrl;
  final http.Client _httpClient;
  final Future<void> Function()? _onUnauthorized;

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _uri(path, queryParameters: queryParameters);
    var response = await _get(uri);

    if (response.statusCode == 401) {
      final refreshed = await _authService.refreshToken();
      if (refreshed) {
        response = await _get(uri);
      }
      if (!refreshed || response.statusCode == 401) {
        await _handleUnauthorized();
      }
    }

    return _decode(response);
  }

  Future<void> _handleUnauthorized() async {
    final onUnauthorized = _onUnauthorized;
    if (onUnauthorized != null) {
      await onUnauthorized();
      return;
    }
    await _authService.clearTokens();
  }

  Future<http.Response> _get(Uri uri) async {
    return _httpClient.get(
      uri,
      headers: await _headers(),
    );
  }

  Future<Map<String, String>> _headers() async {
    final authHeader = await _authService.getAuthHeader();
    return {
      'Accept': 'application/json',
      if (authHeader != null) 'Authorization': authHeader,
    };
  }

  Uri _uri(String path, {Map<String, String>? queryParameters}) {
    final normalizedBaseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$normalizedBaseUrl$normalizedPath').replace(
      queryParameters: queryParameters,
    );
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode);
    }
    if (response.bodyBytes.isEmpty) return null;
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

class ApiException implements Exception {
  const ApiException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'Invalid response: $statusCode';
}
