class TokenRefreshException implements Exception {
  const TokenRefreshException(this.reason, {this.code});

  final String reason;
  final String? code;

  @override
  String toString() => reason;
}
