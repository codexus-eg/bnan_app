import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCacheHelper {
  SecureCacheHelper._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> saveData({
    required String key,
    required String value,
  }) async {
    await _run('write', () => _storage.write(key: key, value: value));
  }

  static Future<String?> getData({required String key}) async {
    return _run('read', () => _storage.read(key: key));
  }

  static Future<void> removeData({required String key}) async {
    await _run('delete', () => _storage.delete(key: key));
  }

  static Future<void> clearAll() async {
    await _run('deleteAll', _storage.deleteAll);
  }

  static Future<bool> debugStorageTest() async {
    const key = 'secure_storage_test_key';
    const value = 'secure_storage_test_value';

    try {
      await _storage.delete(key: key);
      await _storage.write(key: key, value: value);
      final storedValue = await _storage.read(key: key);
      final succeeded = storedValue == value;
      debugPrint('Secure storage test success: $succeeded');
      return succeeded;
    } catch (error, stackTrace) {
      _logError('test', error, stackTrace);
      return false;
    }
  }

  static Future<T> _run<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
      rethrow;
    }
  }

  static void _logError(String operation, Object error, StackTrace stackTrace) {
    if (!kDebugMode) return;
    debugPrint('Secure storage $operation error: ${error.runtimeType}: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
