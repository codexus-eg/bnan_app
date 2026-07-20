import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  String? _userId;
  String? _userRole;
  String? _accessToken;
  String? _refreshToken;

  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userId = userId;
    _userRole = userRole;

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

  Future<void> loadSession() async {
    _accessToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.accessToken,
    );

    _refreshToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.refreshToken,
    );

    _userId = await SecureCacheHelper.getData(
      key: SecureCacheKeys.userId,
    );

    _userRole = await SecureCacheHelper.getData(
      key: SecureCacheKeys.userRole,
    );
  }

  Future<String?> getAccessToken() async {
    return _accessToken ??
        await SecureCacheHelper.getData(
          key: SecureCacheKeys.accessToken,
        );
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken ??
        await SecureCacheHelper.getData(
          key: SecureCacheKeys.refreshToken,
        );
  }

  Future<String?> getUserId() async {
    return _userId ??
        await SecureCacheHelper.getData(
          key: SecureCacheKeys.userId,
        );
  }

  Future<String?> getUserRole() async {
    return _userRole ??
        await SecureCacheHelper.getData(
          key: SecureCacheKeys.userRole,
        );
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    _userId = null;
    _userRole = null;

    await SecureCacheHelper.clearAll();
  }
}