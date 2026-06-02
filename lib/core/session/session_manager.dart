import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {
    await Future.wait([
      SecureCacheHelper.saveData(
        key: SecureCacheKeys.accessToken,
        value: accessToken,
      ),
      SecureCacheHelper.saveData(
        key: SecureCacheKeys.refreshToken,
        value: refreshToken,
      ),
      if (userId != null)
        SecureCacheHelper.saveData(
          key: SecureCacheKeys.userId,
          value: userId,
        ),
      if (userRole != null)
        SecureCacheHelper.saveData(
          key: SecureCacheKeys.userRole,
          value: userRole,
        ),
    ]);
  }

  Future<String?> getAccessToken() {
    return SecureCacheHelper.getData(key: SecureCacheKeys.accessToken);
  }

  Future<String?> getRefreshToken() {
    return SecureCacheHelper.getData(key: SecureCacheKeys.refreshToken);
  }

  Future<String?> getUserId() {
    return SecureCacheHelper.getData(key: SecureCacheKeys.userId);
  }

  Future<String?> getUserRole() {
    return SecureCacheHelper.getData(key: SecureCacheKeys.userRole);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await SecureCacheHelper.clearAll();
  }
}