import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/current_user.dart';
import 'package:bnan_app/core/session/saved_account_store.dart';
import 'package:flutter/foundation.dart';

typedef SessionChangeListener =
    Future<void> Function(String? previousUserId, String? nextUserId);
typedef SessionWillClearListener = Future<void> Function();
typedef AccessTokenChangeListener = void Function(String? accessToken);

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

  CurrentUser? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  RegistrationMode? _registrationMode;
  List<RegistrationMode> _registrationModes = const [];
  final Set<SessionChangeListener> _sessionChangeListeners = {};
  final Set<SessionWillClearListener> _beforeClearListeners = {};
  final Set<AccessTokenChangeListener> _accessTokenChangeListeners = {};

  CurrentUser? get currentUser => _currentUser;
  String? get userId => _currentUser?.id;
  String? get userRole => _currentUser?.role;
  UserRole? get role => UserRole.fromValue(userRole);
  String? get userName => _currentUser?.fullName;
  String? get userEmail => _currentUser?.email;
  String? get userPhone => _currentUser?.phone;
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

  void removeAccessTokenChangeListener(AccessTokenChangeListener listener) =>
      _accessTokenChangeListeners.remove(listener);

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
  // bool get canAccessTeacherSubjectRequests =>
  //     role == UserRole.teacher &&
  //     (hasEgyptianRegistration || hasGulfRegistration);

bool get canAccessTeacherSubjectRequests =>
    role == UserRole.teacher;
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? userRole,
    String? userName,
    String? userEmail,
    String? userPhone,
    RegistrationMode? registrationMode,
    List<RegistrationMode> registrationModes = const [],
  }) async {
    debugPrint('SessionManager.saveSession started');
    final previousUserId = this.userId;

    _currentUser = CurrentUser(
      id: _present(userId),
      role: _present(userRole),
      fullName: _present(userName),
      email: _present(userEmail),
      phone: _present(userPhone),
      registrationMode: registrationMode,
      registrationModes: List.unmodifiable(registrationModes),
    );
    _registrationMode = registrationMode;
    _registrationModes = List.unmodifiable(registrationModes);

    await saveTokens(accessToken: accessToken, refreshToken: refreshToken);

    await _saveOptional(SecureCacheKeys.userId, _currentUser?.id);
    await _saveOptional(SecureCacheKeys.userRole, _currentUser?.role);
    await _saveOptional(SecureCacheKeys.userName, _currentUser?.fullName);
    await _saveOptional(SecureCacheKeys.userEmail, _currentUser?.email);
    await _saveOptional(SecureCacheKeys.userPhone, _currentUser?.phone);

    await _saveOptionalMode(registrationMode);
    await _saveModes(registrationModes);
    if (previousUserId != this.userId) {
      await _notifySessionChanged(previousUserId, this.userId);
    }
  }

  Future<void> loadSession() async {
    _accessToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.accessToken,
    );

    _refreshToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.refreshToken,
    );

    final mode = RegistrationMode.fromValue(
      await SecureCacheHelper.getData(key: SecureCacheKeys.registrationMode),
    );
    final modes = RegistrationMode.fromList(
      (await SecureCacheHelper.getData(
        key: SecureCacheKeys.registrationModes,
      ))?.split(','),
    );
    _currentUser = CurrentUser(
      id: await SecureCacheHelper.getData(key: SecureCacheKeys.userId),
      role: await SecureCacheHelper.getData(key: SecureCacheKeys.userRole),
      fullName: await SecureCacheHelper.getData(key: SecureCacheKeys.userName),
      email: await SecureCacheHelper.getData(key: SecureCacheKeys.userEmail),
      phone: await SecureCacheHelper.getData(key: SecureCacheKeys.userPhone),
      registrationMode: mode,
      registrationModes: List.unmodifiable(modes),
    );
    _registrationMode = mode;
    _registrationModes = List.unmodifiable(modes);
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
    await _saveCurrentAccount();
    for (final listener in List.of(_accessTokenChangeListeners)) {
      listener(accessToken);
    }
  }

  Future<void> clearTokens() async {
    await _notifyBeforeSessionClear();
    _accessToken = null;
    _refreshToken = null;
    await SecureCacheHelper.removeData(key: SecureCacheKeys.accessToken);
    await SecureCacheHelper.removeData(key: SecureCacheKeys.refreshToken);
    for (final listener in List.of(_accessTokenChangeListeners)) {
      listener(null);
    }
  }

  Future<String?> getUserId() async {
    return userId ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userId);
  }

  Future<String?> getUserRole() async {
    return userRole ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userRole);
  }

  Future<String?> getUserName() async {
    return userName ??
        await SecureCacheHelper.getData(key: SecureCacheKeys.userName);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    debugPrint('SessionManager.clearSession started');
    final previousUserId = userId;

    await _notifyBeforeSessionClear();

    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;
    _registrationMode = null;
    _registrationModes = const [];

    for (final key in SecureCacheKeys.sessionKeys) {
      await SecureCacheHelper.removeData(key: key);
    }
    await _notifySessionChanged(previousUserId, null);
    debugPrint('SessionManager.clearSession completed');
  }

  Future<void> _notifySessionChanged(String? previous, String? next) async {
    for (final listener in List.of(_sessionChangeListeners)) {
      await listener(previous, next);
    }
  }

  Future<void> _notifyBeforeSessionClear() async {
    if (_accessToken?.isNotEmpty != true) return;
    for (final listener in List.of(_beforeClearListeners)) {
      try {
        await listener();
      } catch (error) {
        debugPrint('Before session clear hook failed: ${error.runtimeType}');
      }
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

  Future<void> replaceTeacherRegistrationModes(
    Iterable<RegistrationMode> modes,
  ) async {
    _registrationModes = List.unmodifiable(modes.toSet());
    await _saveModes(_registrationModes);
    await _saveCurrentAccount();
  }

  Future<void> mergeCurrentUser({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
  }) async {
    final current = _currentUser;
    if (current == null) return;
    _currentUser = current.merge(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
    );
    await _saveOptional(SecureCacheKeys.userId, _currentUser?.id);
    await _saveOptional(SecureCacheKeys.userRole, _currentUser?.role);
    await _saveOptional(SecureCacheKeys.userName, _currentUser?.fullName);
    await _saveOptional(SecureCacheKeys.userEmail, _currentUser?.email);
    await _saveOptional(SecureCacheKeys.userPhone, _currentUser?.phone);
    await _saveCurrentAccount();
  }

  Future<void> _saveCurrentAccount() async {
    final user = _currentUser;
    if (user == null || _refreshToken?.isNotEmpty != true) return;
    await SavedAccountStore.upsert(
      SavedAccount(
        userId: user.id ?? '',
        name: user.fullName ?? '',
        role: user.role ?? '',
        email: user.email ?? '',
        phone: user.phone ?? '',
        refreshToken: _refreshToken!,
        registrationMode: _registrationMode,
        registrationModes: _registrationModes,
      ),
    );
  }

  Future<void> _saveOptional(String key, String? value) {
    return value == null
        ? SecureCacheHelper.removeData(key: key)
        : SecureCacheHelper.saveData(key: key, value: value);
  }
}

String? _present(String? value) {
  final trimmed = value?.trim();
  return trimmed?.isNotEmpty == true ? trimmed : null;
}
