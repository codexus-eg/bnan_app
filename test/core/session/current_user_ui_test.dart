import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  for (final role in ['admin', 'supervisor', 'teacher', 'student', 'parent']) {
    testWidgets('$role identity uses the centralized name and localized role', (
      tester,
    ) async {
      await SessionManager.instance.saveSession(
        accessToken: 'token',
        refreshToken: 'refresh',
        userRole: role,
        userName: 'Current $role',
      );
      await tester.pumpWidget(_IdentityProbe());

      expect(find.text('Current $role'), findsOneWidget);
      expect(find.byKey(const Key('role')), findsOneWidget);
    });
  }

  testWidgets('empty full name falls back to email', (tester) async {
    await SessionManager.instance.saveSession(
      accessToken: 'token',
      refreshToken: 'refresh',
      userRole: 'parent',
      userEmail: 'parent@bnan.test',
    );
    await tester.pumpWidget(_IdentityProbe());
    expect(find.text('parent@bnan.test'), findsOneWidget);
  });
}

class _IdentityProbe extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Builder(
      builder: (context) => Column(
        children: [
          Text(CurrentUserUi.name(context)),
          Text(CurrentUserUi.role(context), key: const Key('role')),
        ],
      ),
    ),
  );
}
