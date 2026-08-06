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

  test('restores registration data and helpers from secure storage', () async {
    FlutterSecureStorage.setMockInitialValues({
      SecureCacheKeys.userRole: 'teacher',
      SecureCacheKeys.registrationMode: 'egyptian',
      SecureCacheKeys.registrationModes: 'gulf,egyptian,unknown',
    });

    await session.loadSession();

    expect(session.registrationMode, RegistrationMode.egyptian);
    expect(session.registrationModes, containsAll(RegistrationMode.values));
    expect(session.hasEgyptianRegistration, isTrue);
    expect(session.hasGulfRegistration, isTrue);
  });

  test('student and supervisor helpers respect the current role', () async {
    await session.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userRole: 'student',
      registrationMode: RegistrationMode.gulf,
    );
    expect(session.isGulfStudent, isTrue);
    expect(session.isGulfSupervisor, isFalse);
    expect(
      await SecureCacheHelper.getData(key: SecureCacheKeys.registrationMode),
      'gulf',
    );
    expect(
      await SecureCacheHelper.getData(key: SecureCacheKeys.registrationModes),
      isNull,
    );

    await session.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userRole: 'supervisor',
      registrationMode: RegistrationMode.egyptian,
    );
    expect(session.isEgyptianSupervisor, isTrue);
    expect(session.isEgyptianStudent, isFalse);
  });

  test('missing values stay empty and logout clears them', () async {
    await session.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userRole: 'teacher',
      registrationModes: const [RegistrationMode.gulf],
    );
    await session.clearSession();
    await session.loadSession();

    expect(session.registrationMode, isNull);
    expect(session.registrationModes, isEmpty);
    expect(session.hasGulfRegistration, isFalse);
  });
}
