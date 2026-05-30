class AppConfig {
  const AppConfig({
    required this.api,
    required this.auth,
  });

  static const _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.plyglo.com',
  );
  static const _authBaseUrl = String.fromEnvironment(
    'AUTH_BASE_URL',
    defaultValue: 'https://auth.plyglo.com',
  );
  static const _keycloakRealm = String.fromEnvironment(
    'KEYCLOAK_REALM',
    defaultValue: 'study',
  );

  static final current = AppConfig(
    api: _apiBaseUrl,
    auth: _joinUrl(_authBaseUrl, '/realms/$_keycloakRealm'),
  );

  final String api;
  final String auth;

  static String _joinUrl(String baseUrl, String path) {
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$normalizedBaseUrl$normalizedPath';
  }
}
