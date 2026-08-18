import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/session/saved_account_store.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  test(
    'logout keeps all accounts and always returns to saved accounts',
    () async {
      await _login('first', 'first@bnan.test');
      await SessionManager.instance.clearSession();
      expect(await AppLogout.destinationAfterLogout(), Routes.savedAccounts);

      await _login('second', 'second@bnan.test');
      await SessionManager.instance.clearSession();

      final accounts = await SavedAccountStore.load();
      expect(accounts.map((account) => account.userId), ['second', 'first']);
      expect(await AppLogout.destinationAfterLogout(), Routes.savedAccounts);
    },
  );

  test('logout returns to login when no account is saved', () async {
    expect(await AppLogout.destinationAfterLogout(), Routes.logIn);
  });
}

Future<void> _login(String id, String email) =>
    SessionManager.instance.saveSession(
      accessToken: 'access-$id',
      refreshToken: 'refresh-$id',
      userId: id,
      userRole: 'student',
      userName: 'User $id',
      userEmail: email,
    );
