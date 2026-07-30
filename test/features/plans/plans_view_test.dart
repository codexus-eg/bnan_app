import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/plans/presentation/views/plans_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('student sees the read-only responsive view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPlans(tester, 'student');

    expect(find.text('Daily Plans'), findsOneWidget);
    expect(find.text('Add a daily plan for students'), findsNothing);
    expect(find.text('Upload study plan'), findsNothing);
    expect(find.text('Grade'), findsNothing);
    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.byType(CustomTableRow), findsWidgets);
    expect(find.byType(CustomTableCell), findsWidgets);
    expect(find.text('Thursday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('plans table supports Arabic RTL at 360px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPlans(tester, 'student', locale: const Locale('ar'));

    expect(find.text('الخميس'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supervisor add dialog includes teacher selector', (
    tester,
  ) async {
    await pumpPlans(tester, 'supervisor');
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher add dialog omits teacher selector', (tester) async {
    await pumpPlans(tester, 'teacher');
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> pumpPlans(
  WidgetTester tester,
  String role, {
  Locale locale = const Locale('en'),
}) async {
  FlutterSecureStorage.setMockInitialValues({});
  await SessionManager.instance.saveSession(
    accessToken: 'test-access-token',
    refreshToken: 'test-refresh-token',
    userRole: role,
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const PlansView(),
    ),
  );
}
