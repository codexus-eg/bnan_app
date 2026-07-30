import 'package:bnan_app/features/supervisor_home/presentation/views/supervisor_home_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders at 360px and opens its shared drawer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    final state = tester.state<SupervisorHomeViewState>(
      find.byType(SupervisorHomeView),
    );
    state.scaffoldKey.currentState?.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Supervisor'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled attendance navigation does not crash', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Attendance').last);
    await tester.pumpAndSettle();

    expect(find.byType(SupervisorHomeView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports the Arabic RTL layout at 360px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(testApp(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}

Widget testApp({Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const SupervisorHomeView(
      userName: 'A very long supervisor display name for overflow testing',
    ),
  );
}
