import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/meta_section.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_details_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting();
    await S.load(const Locale('ar'));
  });

  group('AppPickers.formatDateTime', () {
    test('formats ISO string in local time with Arabic AM/PM', () {
      const iso = '2026-09-08T13:41:36.418Z';
      final parsed = DateTime.parse(iso).toLocal();
      final expectedDate = DateFormat('dd/MM/yyyy', 'en').format(parsed);
      final expectedTime = DateFormat('hh:mm a', 'ar').format(parsed);
      final expected = '$expectedDate • $expectedTime';

      final result = AppPickers.formatDateTime(iso, locale: 'ar');
      expect(result, expected);
    });

    test('formats ISO string in local time with English AM/PM', () {
      const iso = '2026-09-08T13:41:36.418Z';
      final parsed = DateTime.parse(iso).toLocal();
      final expectedDate = DateFormat('dd/MM/yyyy', 'en').format(parsed);
      final expectedTime = DateFormat('hh:mm a', 'en').format(parsed);
      final expected = '$expectedDate • $expectedTime';

      final result = AppPickers.formatDateTime(iso, locale: 'en');
      expect(result, expected);
    });

    test('handles empty or dash gracefully', () {
      expect(AppPickers.formatDateTime(''), '');
      expect(AppPickers.formatDateTime('  '), '');
      expect(AppPickers.formatDateTime('-'), '');
    });
  });

  group('Users Management UI Date Display', () {
    const testUser = UserItem(
      id: 'usr-1',
      name: 'Test User',
      phone: '01000000000',
      email: 'test@example.com',
      registrationDate: '2026-09-08T13:41:36.418Z',
      parentName: '',
      classes: '',
      roles: 'teacher',
      status: 'active',
      createdAt: '2026-09-08T13:41:36.418Z',
      updatedAt: '',
      curriculum: [],
      grade: [],
    );

    testWidgets('MetaSection displays formatted date and time in Arabic', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: MetaSection(user: testUser)),
        ),
      );

      final parsed = DateTime.parse(testUser.registrationDate).toLocal();
      final expectedTime = DateFormat('hh:mm a', 'ar').format(parsed);
      expect(find.textContaining(expectedTime), findsOneWidget);
    });

    testWidgets('DialogDetailsBody displays formatted date and time', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: DialogDetailsBody(user: testUser)),
        ),
      );

      final parsed = DateTime.parse(testUser.registrationDate).toLocal();
      final expectedTime = DateFormat('hh:mm a', 'ar').format(parsed);
      expect(find.textContaining(expectedTime), findsOneWidget);
    });
  });
}
