import 'package:bnan_app/core/session/session_manager.dart';

abstract interface class TokenStore {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
}

class SessionTokenStore implements TokenStore {
  const SessionTokenStore();

  @override
  Future<String?> getAccessToken() => SessionManager.instance.getAccessToken();

  @override
  Future<String?> getRefreshToken() =>
      SessionManager.instance.getRefreshToken();

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) => SessionManager.instance.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
