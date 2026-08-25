import 'dart:io';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/push_notifications/data/installation_id_store.dart';
import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PushTokenRegistrar {
  PushTokenRegistrar(this._messaging, this._repo, this._installationIds);
  final PushMessaging _messaging;
  final DeviceTokenRepo _repo;
  final InstallationIdStore _installationIds;
  static const _permissionKey = 'push_permission_requested';
  static const _registeredTokenKey = 'registered_push_token';
  static const _registeredOwnerKey = 'registered_push_owner';
  static const _registeredVersionKey = 'registered_push_version';
  Future<void> _operations = Future.value();
  Future<void>? _unregisterOperation;
  bool _registrationEnabled = false;

  Future<void> registerCurrent() async {
    if (SessionManager.instance.accessToken?.isNotEmpty != true) return;
    debugPrint('[FCM] login registration start');
    _registrationEnabled = true;
    _unregisterOperation = null;
    try {
      await _requestPermissionOnce();
      final token = await _messaging.getToken();
      if (token?.isNotEmpty == true) {
        await _enqueue(() => _register(token!));
      }
    } catch (error) {
      _debug('Push token registration failed', error);
    }
  }

  Future<void> register(String token) => _enqueue(() => _register(token));

  Future<void> _register(String token) async {
    if (!_registrationEnabled) return;
    final session = SessionManager.instance;
    final owner = '${session.userId?.trim() ?? ''}|${session.userRole ?? ''}';
    if (SessionManager.instance.accessToken?.isEmpty != false) return;
    final package = await PackageInfo.fromPlatform();
    final registeredToken = _cached(_registeredTokenKey);
    final registeredOwner = _cached(_registeredOwnerKey);
    if (registeredToken == token &&
        registeredOwner == owner &&
        CacheHelper.getData(key: _registeredVersionKey) == package.version) {
      return;
    }
    if (registeredToken.isNotEmpty &&
        (registeredToken != token || registeredOwner != owner)) {
      await _repo.delete(token: registeredToken);
    }
    final deviceId = await _installationIds.getOrCreate();
    await _repo.register(
      DeviceTokenPayload(
        token: token,
        platform: Platform.isIOS ? 'ios' : 'android',
        deviceId: deviceId,
        appVersion: package.version,
      ),
    );
    await CacheHelper.saveData(key: _registeredTokenKey, value: token);
    await CacheHelper.saveData(key: _registeredOwnerKey, value: owner);
    await CacheHelper.saveData(
      key: _registeredVersionKey,
      value: package.version,
    );
    debugPrint('[FCM] token registered');
  }

  Future<void> deleteCurrent() {
    _registrationEnabled = false;
    return _unregisterOperation ??= _enqueue(_deleteCurrentBestEffort);
  }

  Future<void> _deleteCurrentBestEffort() async {
    debugPrint('[FCM] unregister start');
    try {
      await _deleteCurrent();
    } catch (error) {
      _debug('FCM unregister failed', error);
    }
  }

  Future<void> _deleteCurrent() async {
    var backendFailed = false;
    final tokens = <String>{_cached(_registeredTokenKey)};
    try {
      tokens.add((await _messaging.getToken())?.trim() ?? '');
    } catch (error) {
      backendFailed = true;
      _debug('Push token lookup failed', error);
    }
    for (final token in tokens.where((value) => value.isNotEmpty)) {
      try {
        await _repo.delete(token: token);
      } catch (error) {
        backendFailed = true;
        _debug('Push token deletion failed', error);
      }
    }
    debugPrint(
      backendFailed
          ? '[FCM] backend unregister failed'
          : '[FCM] backend unregister success',
    );
    try {
      await _messaging.deleteToken();
      debugPrint('[FCM] firebase token deleted');
    } catch (error) {
      _debug('Push token invalidation failed', error);
    }
    await CacheHelper.removeData(key: _registeredTokenKey);
    await CacheHelper.removeData(key: _registeredOwnerKey);
    await CacheHelper.removeData(key: _registeredVersionKey);
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final next = _operations.then((_) => action(), onError: (_) => action());
    _operations = next.catchError((_) {});
    return next;
  }

  String _cached(String key) =>
      CacheHelper.getData(key: key)?.toString().trim() ?? '';

  Future<void> _requestPermissionOnce() async {
    if (CacheHelper.getData(key: _permissionKey) == true) return;
    await _messaging.requestPermission();
    await CacheHelper.saveData(key: _permissionKey, value: true);
  }

  void _debug(String message, Object error) {
    if (kDebugMode) debugPrint('$message: ${error.runtimeType}');
  }
}
