import 'package:bnan_app/features/chats/presentation/utils/chat_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses room name then localized fallback', (tester) async {
    late BuildContext context;
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
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(resolveChatTitle(context, '  الرياضيات  '), 'الرياضيات');
    expect(resolveChatTitle(context, null), S.of(context).chatTitleFallback);
  });
}
