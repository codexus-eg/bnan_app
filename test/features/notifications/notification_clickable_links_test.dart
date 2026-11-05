import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notification_navigation.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/global_notification_details_content.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/linkified_notification_text.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_url_parser.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  group('NotificationUrlParser unit tests', () {
    test('1. Parses single URL in Arabic text', () {
      const text = 'الكتب الدراسية متاحة هنا: https://drive.google.com/folder';
      final parts = NotificationUrlParser.parse(text);

      expect(parts.length, 2);
      expect(parts[0].isUrl, isFalse);
      expect(parts[0].text, 'الكتب الدراسية متاحة هنا: ');
      expect(parts[1].isUrl, isTrue);
      expect(parts[1].text, 'https://drive.google.com/folder');
    });

    test('2. Parses multiple URLs in text', () {
      const text = 'الرابط الأول: https://drive.google.com/1 والرابط الثاني: https://example.com/page';
      final parts = NotificationUrlParser.parse(text);

      final urlParts = parts.where((p) => p.isUrl).map((p) => p.text).toList();
      expect(urlParts, [
        'https://drive.google.com/1',
        'https://example.com/page',
      ]);
    });

    test('3. Parses Google Drive URL with query parameters', () {
      const text = 'https://drive.google.com/drive/folders/1IwiibncS3chWSbblZgKasWfGx-pq3ilo?usp=sharing';
      final parts = NotificationUrlParser.parse(text);

      expect(parts.length, 1);
      expect(parts[0].isUrl, isTrue);
      expect(
        parts[0].text,
        'https://drive.google.com/drive/folders/1IwiibncS3chWSbblZgKasWfGx-pq3ilo?usp=sharing',
      );
    });

    test('4. Correctly strips trailing Arabic and English punctuation from URLs', () {
      final tests = {
        'رابط الكتب: https://drive.google.com/test، والمزيد': 'https://drive.google.com/test',
        'راجع https://example.com/info.': 'https://example.com/info',
        'هل شاهدت https://example.com/faq؟': 'https://example.com/faq',
        'الموقع: https://example.com/docs؛ يرجى المتابعة': 'https://example.com/docs',
        'اقرأ هنا (https://example.com/nested)': 'https://example.com/nested',
        'انظر https://example.com/link!': 'https://example.com/link',
      };

      for (final entry in tests.entries) {
        final parts = NotificationUrlParser.parse(entry.key);
        final urlPart = parts.firstWhere((p) => p.isUrl);
        expect(urlPart.text, entry.value);
      }
    });

    test('5. Plain notifications without URLs return single non-url part', () {
      const text = 'تنبيه: ستبدأ الحصة بعد عشر دقائق، يرجى الاستعداد.';
      final parts = NotificationUrlParser.parse(text);

      expect(parts.length, 1);
      expect(parts[0].isUrl, isFalse);
      expect(parts[0].text, text);
    });

    test('6. Rejects invalid and unsupported schemes', () {
      const text = 'javascript:alert(1) tel:12345 ftp://files.com';
      final parts = NotificationUrlParser.parse(text);

      expect(parts.every((p) => !p.isUrl), isTrue);
    });

    test('7. Preserves emojis and line breaks in mixed RTL/LTR text', () {
      const text = 'أهلاً بكم 🌟\nتحميل الملف: https://example.com/doc.pdf\nبالتوفيق! 🎉';
      final parts = NotificationUrlParser.parse(text);

      expect(parts.length, 3);
      expect(parts[0].text, 'أهلاً بكم 🌟\nتحميل الملف: ');
      expect(parts[1].text, 'https://example.com/doc.pdf');
      expect(parts[1].isUrl, isTrue);
      expect(parts[2].text, '\nبالتوفيق! 🎉');
    });
  });

  group('LinkifiedNotificationText widget tests', () {
    testWidgets('8. Correctly renders clickable text spans and invokes tap callback', (tester) async {
      String? launchedUrl;
      const text = 'الكتب: https://drive.google.com/folders/test?usp=sharing';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: LinkifiedNotificationText(
              text: text,
              onTapUrl: (url) => launchedUrl = url,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final richText = tester.widget<RichText>(richTextFinder);
      final rootSpan = richText.text as TextSpan;
      final innerSpan = (rootSpan.children?.length == 1 &&
              (rootSpan.children![0] as TextSpan).children != null)
          ? rootSpan.children![0] as TextSpan
          : rootSpan;
      expect(innerSpan.children?.length, 2);

      final urlSpan = innerSpan.children![1] as TextSpan;
      expect(urlSpan.text, 'https://drive.google.com/folders/test?usp=sharing');
      expect(urlSpan.recognizer, isA<TapGestureRecognizer>());

      (urlSpan.recognizer as TapGestureRecognizer).onTap?.call();
      expect(launchedUrl, 'https://drive.google.com/folders/test?usp=sharing');
    });

    testWidgets('9. GlobalNotificationDetailsContent renders LinkifiedNotificationText', (tester) async {
      final notification = AppNotification(
        id: 'notif_1',
        type: 'broadcast',
        key: 'BROADCAST_NOTIFICATION',
        title: 'رابط الكتب',
        body: 'الكتب متاحة هنا: https://drive.google.com/drive/folders/1IwiibncS3chWSbblZgKasWfGx-pq3ilo?usp=sharing',
        navigation: const NotificationNavigation(screen: 'global_notification_details', params: {}),
        data: const {},
        isRead: true,
        createdAt: DateTime(2026, 10, 27, 10, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: GlobalNotificationDetailsContent(
              notification: notification,
              showRetry: false,
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LinkifiedNotificationText), findsOneWidget);
      expect(find.text('رابط الكتب'), findsOneWidget);
    });
  });
}
