class TokenModel {
  final String accessToken;
  final String? refreshToken;
  final DateTime accessTokenExpiry;
  final DateTime refreshTokenExpiry;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiry,
    required this.refreshTokenExpiry,
  });

  factory TokenModel.fromOAuthResponse({
    required String accessToken,
    required String? refreshToken,
    required DateTime? accessTokenExpirationDateTime,
  }) {
    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiry: accessTokenExpirationDateTime ??
          DateTime.now().add(const Duration(minutes: 5)),
      refreshTokenExpiry: DateTime.now().add(const Duration(days: 30)),
    );
  }

  factory TokenModel.fromStoredAccessToken(String? accessToken) {
    return TokenModel(
      accessToken: accessToken ?? '',
      refreshToken: null,
      accessTokenExpiry: DateTime.now().add(const Duration(minutes: 5)),
      refreshTokenExpiry: DateTime.now().add(const Duration(days: 30)),
    );
  }

  bool get isAccessTokenValid => accessTokenExpiry.isAfter(DateTime.now());
  bool get isRefreshTokenValid => refreshTokenExpiry.isAfter(DateTime.now());
}
