class AppConfig {
  const AppConfig({
    required this.api,
    required this.auth,
  });

  static const _domain = String.fromEnvironment(
    'APP_DOMAIN',
    defaultValue: 'plyglo.com',
  );
  static const _scheme = String.fromEnvironment(
    'APP_SCHEME',
    defaultValue: 'http',
  );
  static const _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const _authBaseUrlOverride = String.fromEnvironment(
    'AUTH_BASE_URL',
    defaultValue: '',
  );

  static final current = AppConfig(
    api: ApiConfig(
      baseUrl: _apiBaseUrlOverride.isNotEmpty
          ? _apiBaseUrlOverride
          : '$_scheme://api.$_domain',
    ),
    auth: AuthConfig(
      baseUrl: _authBaseUrlOverride.isNotEmpty
          ? _authBaseUrlOverride
          : '$_scheme://auth.$_domain',
      realm: const String.fromEnvironment(
        'KEYCLOAK_REALM',
        defaultValue: 'study',
      ),
      clientId: const String.fromEnvironment(
        'KEYCLOAK_CLIENT_ID',
        defaultValue: 'frontend',
      ),
      redirectScheme: const String.fromEnvironment(
        'KEYCLOAK_REDIRECT_SCHEME',
        defaultValue: 'com.poliglotim.app',
      ),
    ),
  );

  final ApiConfig api;
  final AuthConfig auth;
}

class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
  });

  final String baseUrl;
}

class AuthConfig {
  const AuthConfig({
    required this.baseUrl,
    required this.realm,
    required this.clientId,
    required this.redirectScheme,
  });

  final String baseUrl;
  final String realm;
  final String clientId;
  final String redirectScheme;

  List<String> get scopes => const [
        'openid',
        'profile',
        'email',
      ];

  String get issuer => '$baseUrl/realms/$realm';
  String get authorizeEndpoint => '$issuer/protocol/openid-connect/auth';
  String get tokenEndpoint => '$issuer/protocol/openid-connect/token';
  String get userInfoEndpoint => '$issuer/protocol/openid-connect/userinfo';
  String get nativeRedirectUrl => '$redirectScheme:/callback';
}
