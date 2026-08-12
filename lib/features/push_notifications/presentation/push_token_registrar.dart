import 'dart:io';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/push_notifications/data/installation_id_store.dart';
import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PushTokenRegistrar {
  PushTokenRegistrar(this._messaging, this._repo, this._installationIds);
  final FirebaseMessaging _messaging;
  final DeviceTokenRepo _repo;
  final InstallationIdStore _installationIds;
  static const _permissionKey = 'push_permission_requested';
  static const _registeredTokenKey = 'registered_push_token';
  static const _registeredOwnerKey = 'registered_push_owner';
  static const _registeredVersionKey = 'registered_push_version';

  Future<void> registerCurrent() async {
    if (SessionManager.instance.accessToken?.isNotEmpty != true) return;
    try {
      await _requestPermissionOnce();
      final token = await _messaging.getToken();
      if (token?.isNotEmpty == true) {
        await register(token!);
      }
    } catch (error) {
      _debug('Push token registration failed', error);
    }
  }

  Future<void> register(String token) async {
    final owner = SessionManager.instance.userId?.trim() ?? '';
    if (SessionManager.instance.accessToken?.isEmpty != false) return;
    final package = await PackageInfo.fromPlatform();
    if (CacheHelper.getData(key: _registeredTokenKey) == token &&
        CacheHelper.getData(key: _registeredOwnerKey) == owner &&
        CacheHelper.getData(key: _registeredVersionKey) == package.version) {
      return;
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
  }

  Future<void> deleteCurrent() async {
    try {
      final token = await _messaging.getToken();
      if (token?.isNotEmpty == true) {
        await _repo.delete(
          token: token!,
          deviceId: await _installationIds.getOrCreate(),
        );
      }
    } catch (error) {
      _debug('Push token deletion failed', error);
    } finally {
      await CacheHelper.removeData(key: _registeredTokenKey);
      await CacheHelper.removeData(key: _registeredOwnerKey);
      await CacheHelper.removeData(key: _registeredVersionKey);
    }
  }

  Future<void> _requestPermissionOnce() async {
    if (CacheHelper.getData(key: _permissionKey) == true) return;
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await CacheHelper.saveData(key: _permissionKey, value: true);
  }

  void _debug(String message, Object error) {
    if (kDebugMode) debugPrint('$message: ${error.runtimeType}');
  }
}
