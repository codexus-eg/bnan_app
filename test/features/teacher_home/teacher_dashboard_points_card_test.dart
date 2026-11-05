import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeacherDashboardModel parsing', () {
    test('parses teacherPoints when positive', () {
      final json = {
        'role': 'teacher',
        'teacherPoints': 7,
        'pointsPeriod': {
          'weekStart': '2026-10-24T21:00:00.000Z',
          'weekEnd': '2026-10-31T21:00:00.000Z',
          'cutoff': '2026-10-27T12:00:00.000Z',
          'timezone': 'Africa/Cairo',
        },
        'counts': {'classrooms': 3, 'students': 25, 'subjects': 2},
      };

      final model = TeacherDashboardModel.fromJson(json, null);

      expect(model.teacherPoints, 7);
      expect(model.classrooms, 3);
      expect(model.students, 25);
      expect(model.subjects, 2);
      expect(
        model.pointsPeriod?.weekStart,
        DateTime.parse('2026-10-24T21:00:00.000Z'),
      );
      expect(model.pointsPeriod?.timezone, 'Africa/Cairo');
    });

    test('distinguishes valid zero points from null/missing points', () {
      final zeroJson = {
        'role': 'teacher',
        'teacherPoints': 0,
        'counts': {'classrooms': 1, 'students': 5, 'subjects': 1},
      };
      final missingJson = {
        'role': 'teacher',
        'counts': {'classrooms': 1, 'students': 5, 'subjects': 1},
      };

      final zeroModel = TeacherDashboardModel.fromJson(zeroJson, null);
      final missingModel = TeacherDashboardModel.fromJson(missingJson, null);

      expect(zeroModel.teacherPoints, 0);
      expect(missingModel.teacherPoints, isNull);
    });

    test('ignores deprecated excellence and idealTeacher fields', () {
      final jsonWithDeprecated = {
        'role': 'teacher',
        'teacherPoints': 5,
        'excellence': {'points': 99},
        'idealTeacher': {'points': 88, 'fullName': 'Someone Else'},
        'counts': {'classrooms': 2, 'students': 10, 'subjects': 1},
      };

      final model = TeacherDashboardModel.fromJson(jsonWithDeprecated, null);
      expect(model.teacherPoints, 5);
    });
  });

  group('Teacher Points Card UI', () {
    testWidgets('renders points card with actual value and localized title', (
      tester,
    ) async {
      final s = await S.load(const Locale('ar'));
      final states = [
        HomeStateModel(
          icon: ImageManager.teacherBookTwoIcon,
          value: '3',
          title: s.classes,
        ),
        HomeStateModel(
          icon: ImageManager.userProfileGroupIcon,
          value: '25',
          title: s.students,
        ),
        HomeStateModel(
          icon: ImageManager.teacherBookOneIcon,
          value: '2',
          title: s.subject,
        ),
        HomeStateModel(
          icon: ImageManager.crownSimple,
          value: '7',
          title: s.myPointsThisWeek,
        ),
      ];

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
            body: HomeStatsSection(states: states, crossAxisCount: 2),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('نقاطي هذا الأسبوع'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('renders dash when teacherPoints is null', (tester) async {
      final s = await S.load(const Locale('ar'));
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
            body: HomeStatsSection(
              states: [
                HomeStateModel(
                  icon: ImageManager.crownSimple,
                  value: '—',
                  title: s.myPointsThisWeek,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('نقاطي هذا الأسبوع'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });
  });
}
