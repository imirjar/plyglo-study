// В core/errors/
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, [this.statusCode]);

  @override
  String toString() => "AuthException: $message (code: ${statusCode ?? 'N/A'})";
}
