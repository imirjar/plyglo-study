class AppConfig {
  const AppConfig({
    required this.api,
    required this.auth,
  });

  static final current = AppConfig(
    api: "/api/",
    auth: "/oidc",
  );

  final String api;
  final String auth;
}
