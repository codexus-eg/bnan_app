import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:flutter/foundation.dart';

typedef SessionChangeListener =
    Future<void> Function(String? previousUserId, String? nextUserId);
typedef SessionWillClearListener = Future<void> Function();
typedef AccessTokenChangeListener = void Function(String? accessToken);

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  String? _userId;
  String? _userRole;
  String? _userName;
  String? _accessToken;
  String? _refreshToken;
  RegistrationMode? _registrationMode;
  List<RegistrationMode> _registrationModes = const [];
  final Set<SessionChangeListener> _sessionChangeListeners = {};
  final Set<SessionWillClearListener> _beforeClearListeners = {};
  final Set<AccessTokenChangeListener> _accessTokenChangeListeners = {};

  String? get userId => _userId;
  String? get userRole => _userRole;
  UserRole? get role => UserRole.fromValue(_userRole);
  String? get userName => _userName;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  RegistrationMode? get registrationMode => _registrationMode;
  List<RegistrationMode> get registrationModes => _registrationModes;

  void addSessionChangeListener(SessionChangeListener listener) =>
      _sessionChangeListeners.add(listener);

  void removeSessionChangeListener(SessionChangeListener listener) =>
      _sessionChangeListeners.remove(listener);

  void addBeforeClearListener(SessionWillClearListener listener) =>
      _beforeClearListeners.add(listener);

  void removeBeforeClearListener(SessionWillClearListener listener) =>
      _beforeClearListeners.remove(listener);

  void addAccessTokenChangeListener(AccessTokenChangeListener listener) =>
      _accessTokenChangeListeners.add(listener);

  bool get isEgyptianStudent =>
      role == UserRole.student &&
      _registrationMode == RegistrationMode.egyptian;
  bool get isGulfStudent =>
      role == UserRole.student && _registrationMode == RegistrationMode.gulf;
  bool get isEgyptianSupervisor =>
      role == UserRole.supervisor &&
      _registrationMode == RegistrationMode.egyptian;
  bool get isGulfSupervisor =>
      role == UserRole.supervisor && _registrationMode == RegistrationMode.gulf;
  bool get hasEgyptianRegistration => switch (role) {
    UserRole.student ||
    UserRole.supervisor => _registrationMode == RegistrationMode.egyptian,
    UserRole.teacher => _registrationModes.contains(RegistrationMode.egyptian),
    _ => false,
  };
  bool get hasGulfRegistration => switch (role) {
    UserRole.student ||
    UserRole.supervisor => _registrationMode == RegistrationMode.gulf,
    UserRole.teacher => _registrationModes.contains(RegistrationMode.gulf),
    _ => false,
  };

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
    String? userName,
    RegistrationMode? registrationMode,
    List<RegistrationMode> registrationModes = const [],
  }) async {
    debugPrint('SessionManager.saveSession started');
    final previousUserId = _userId;

    _userId = userId;
    _userRole = userRole;
    _userName = userName;
    _registrationMode = registrationMode;
    _registrationModes = List.unmodifiable(registrationModes);

    await saveTokens(accessToken: accessToken, refreshToken: refreshToken);

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

    await _saveOptionalMode(registrationMode);
    await _saveModes(registrationModes);
    if (previousUserId != userId) {
      await _notifySessionChanged(previousUserId, userId);
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
    _registrationMode = RegistrationMode.fromValue(
      await SecureCacheHelper.getData(key: SecureCacheKeys.registrationMode),
    );
    _registrationModes = List.unmodifiable(
      RegistrationMode.fromList(
        (await SecureCacheHelper.getData(
          key: SecureCacheKeys.registrationModes,
        ))?.split(','),
      ),
    );
  }

  Future<String?> getAccessToken() async {
    return _accessToken ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.refreshToken);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.refreshToken,
      value: refreshToken,
    );
    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.accessToken,
      value: accessToken,
    );
    _refreshToken = refreshToken;
    _accessToken = accessToken;
    for (final listener in List.of(_accessTokenChangeListeners)) {
      listener(accessToken);
    }
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await SecureCacheHelper.removeData(key: SecureCacheKeys.accessToken);
    await SecureCacheHelper.removeData(key: SecureCacheKeys.refreshToken);
    for (final listener in List.of(_accessTokenChangeListeners)) {
      listener(null);
    }
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
    final previousUserId = _userId;

    for (final listener in List.of(_beforeClearListeners)) {
      try {
        await listener();
      } catch (error) {
        debugPrint('Before session clear hook failed: ${error.runtimeType}');
      }
    }

    _accessToken = null;
    _refreshToken = null;
    _userId = null;
    _userRole = null;
    _userName = null;
    _registrationMode = null;
    _registrationModes = const [];

    await SecureCacheHelper.clearAll();
    await _notifySessionChanged(previousUserId, null);
    debugPrint('SessionManager.clearSession completed');
  }

  Future<void> _notifySessionChanged(String? previous, String? next) async {
    for (final listener in List.of(_sessionChangeListeners)) {
      await listener(previous, next);
    }
  }

  Future<void> _saveOptionalMode(RegistrationMode? mode) async {
    if (mode == null) {
      return SecureCacheHelper.removeData(
        key: SecureCacheKeys.registrationMode,
      );
    }
    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.registrationMode,
      value: mode.name,
    );
  }

  Future<void> _saveModes(List<RegistrationMode> modes) async {
    if (modes.isEmpty) {
      return SecureCacheHelper.removeData(
        key: SecureCacheKeys.registrationModes,
      );
    }
    await SecureCacheHelper.saveData(
      key: SecureCacheKeys.registrationModes,
      value: modes.map((mode) => mode.name).join(','),
    );
  }
}
