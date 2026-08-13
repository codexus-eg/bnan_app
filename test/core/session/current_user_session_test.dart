import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final session = SessionManager.instance;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await session.clearSession();
  });

  test('saves and restores the complete current user identity', () async {
    await _login(session, id: 'a', name: 'Admin A', email: 'a@bnan.test');
    await session.loadSession();

    expect(session.userId, 'a');
    expect(session.userName, 'Admin A');
    expect(session.userEmail, 'a@bnan.test');
    expect(session.registrationMode, RegistrationMode.egyptian);
  });

  test('second login fully replaces missing values from first user', () async {
    await _login(session, id: 'a', name: 'Admin A', email: 'a@bnan.test');
    await session.saveSession(
      accessToken: 'teacher-token',
      refreshToken: 'teacher-refresh',
      userId: 'b',
      userRole: 'teacher',
    );

    expect(session.userName, isNull);
    expect(session.userEmail, isNull);
    expect(await _stored(SecureCacheKeys.userName), isNull);
    expect(await _stored(SecureCacheKeys.userEmail), isNull);
  });

  test(
    'profile merge ignores empty fields and preserves session scope',
    () async {
      await _login(session, id: 'a', name: 'Admin A', email: 'a@bnan.test');
      await session.mergeCurrentUser(fullName: '', email: 'new@bnan.test');

      expect(session.userName, 'Admin A');
      expect(session.userEmail, 'new@bnan.test');
      expect(session.userRole, 'admin');
      expect(session.registrationMode, RegistrationMode.egyptian);
    },
  );

  test('logout clears all current user identity fields', () async {
    await _login(session, id: 'a', name: 'Admin A', email: 'a@bnan.test');
    await session.clearSession();

    expect(session.currentUser, isNull);
    expect(await _stored(SecureCacheKeys.userName), isNull);
    expect(await _stored(SecureCacheKeys.userEmail), isNull);
  });
}

Future<void> _login(
  SessionManager session, {
  required String id,
  required String name,
  required String email,
}) => session.saveSession(
  accessToken: 'token-$id',
  refreshToken: 'refresh-$id',
  userId: id,
  userRole: 'admin',
  userName: name,
  userEmail: email,
  registrationMode: RegistrationMode.egyptian,
);

Future<String?> _stored(String key) => SecureCacheHelper.getData(key: key);
