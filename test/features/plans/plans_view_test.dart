import 'package:bnan_app/features/plans/presentation/models/plans_view_mode.dart';
import 'package:bnan_app/features/plans/presentation/views/plans_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('student sees the read-only responsive view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPlans(tester, PlansViewMode.student);

    expect(find.text('Daily Plans'), findsOneWidget);
    expect(find.text('Add a daily plan for students'), findsNothing);
    expect(find.text('Upload study plan'), findsNothing);
    expect(find.text('Grade'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supervisor add dialog includes teacher selector', (
    tester,
  ) async {
    await pumpPlans(tester, PlansViewMode.supervisor);
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher add dialog omits teacher selector', (tester) async {
    await pumpPlans(tester, PlansViewMode.teacher);
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> pumpPlans(WidgetTester tester, PlansViewMode mode) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: PlansView(viewMode: mode),
    ),
  );
}
