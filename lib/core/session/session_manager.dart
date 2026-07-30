import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:flutter/foundation.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  String? _userId;
  String? _userRole;
  String? _userName;
  String? _accessToken;
  String? _refreshToken;

  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
    String? userName,
  }) async {
    debugPrint('SessionManager.saveSession started');

    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userId = userId;
    _userRole = userRole;
    _userName = userName;

    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.accessToken,
      value: accessToken,
    );
    debugPrint('Access token write completed');

    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.refreshToken,
      value: refreshToken,
    );
    debugPrint('Refresh token write completed');

    if (userId != null) {
      await SecureCacheHelper.saveData(
        key: SecureCacheKeys.userId,
        value: userId,
      );
      debugPrint('User id write completed');
    }

    if (userRole != null) {
      await SecureCacheHelper.saveData(
        key: SecureCacheKeys.userRole,
        value: userRole,
      );
      debugPrint('User role write completed');
    }

    if (userName != null) {
      await SecureCacheHelper.saveData(
        key: SecureCacheKeys.userName,
        value: userName,
      );
    }
  }

  Future<void> loadSession() async {
    _accessToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.accessToken,
    );

    _refreshToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.refreshToken,
    );

    _userId = await SecureCacheHelper.getData(key: SecureCacheKeys.userId);

    _userRole = await SecureCacheHelper.getData(key: SecureCacheKeys.userRole);
    _userName = await SecureCacheHelper.getData(key: SecureCacheKeys.userName);
  }

  Future<String?> getAccessToken() async {
    return _accessToken ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.refreshToken);
  }

  Future<String?> getUserId() async {
    return _userId ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userId);
  }

  Future<String?> getUserRole() async {
    return _userRole ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userRole);
  }

  Future<String?> getUserName() async {
    return _userName ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userName);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    debugPrint('SessionManager.clearSession started');

    _accessToken = null;
    _refreshToken = null;
    _userId = null;
    _userRole = null;
    _userName = null;

    await SecureCacheHelper.clearAll();
    debugPrint('SessionManager.clearSession completed');
  }
}
