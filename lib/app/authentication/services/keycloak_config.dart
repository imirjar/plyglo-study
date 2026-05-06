class KeycloakConfig {
  static const baseUrl = String.fromEnvironment(
    'KEYCLOAK_BASE_URL',
    defaultValue: 'http://localhost:9080',
  );
  static const realm = String.fromEnvironment(
    'KEYCLOAK_REALM',
    defaultValue: 'study',
  );
  static const clientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'frontend',
  );
  static const redirectScheme = String.fromEnvironment(
    'KEYCLOAK_REDIRECT_SCHEME',
    defaultValue: 'com.poliglotim.app',
  );

  static const scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  static String get issuer => '$baseUrl/realms/$realm';
  static String get authorizeEndpoint => '$issuer/protocol/openid-connect/auth';
  static String get tokenEndpoint => '$issuer/protocol/openid-connect/token';
  static String get userInfoEndpoint =>
      '$issuer/protocol/openid-connect/userinfo';
  static String get nativeRedirectUrl => '$redirectScheme:/callback';
}
