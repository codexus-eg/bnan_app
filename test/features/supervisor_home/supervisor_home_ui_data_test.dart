import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupervisorHomeUiData Crown Card Removal', () {
    test('completely omits crown card from Supervisor Dashboard summary', () async {
      final sAr = await S.load(const Locale('ar'));
      final dashboard = _dashboard();

      final ui = SupervisorHomeUiData.fromDashboard(sAr, dashboard);

      expect(ui.summary.length, 2);
      expect(
        ui.summary.any((card) => card.icon == ImageManager.crownSimple),
        isFalse,
      );
      expect(ui.summary[0].title, sAr.classes);
      expect(ui.summary[0].value, '7');
      expect(ui.summary[1].title, sAr.evaluations);
      expect(ui.summary[1].value, '5');
    });

    testWidgets('renders exactly 2 cards without crown or placeholder 0', (
      tester,
    ) async {
      final sAr = await S.load(const Locale('ar'));
      final dashboard = _dashboard();
      final ui = SupervisorHomeUiData.fromDashboard(sAr, dashboard);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: HomeStatsSection(states: ui.summary),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('المعلم المثالي'), findsNothing);
      expect(find.text('Ola Abdelfatah'), findsNothing);
    });
  });
}

SupervisorDashboardModel _dashboard() =>
    const SupervisorDashboardModel(
      generatedAt: null,
      classrooms: 7,
      evaluations: 5,
      notifications: [],
    );
