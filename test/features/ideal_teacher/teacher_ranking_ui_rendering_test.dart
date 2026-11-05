import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/component_score_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_card_content.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_header.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  group('TeacherRankingCardContent UI rendering', () {
    testWidgets('Case A: weeklyPoints == 0 renders 0 / 100', (tester) async {
      const teacher = TeacherRankingItemModel(
        rank: 1,
        teacherId: 't1',
        fullName: 'Teacher Zero',
        weeklyPoints: 0,
        components: RankingComponentsModel(
          interaction: ComponentScoreModel(available: true, points: 5, max: 10),
        ),
      );

      await tester.pumpWidget(
        _wrap(
          const TeacherRankingCardContent(
            teacher: teacher,
            selected: false,
            canModify: true,
            canSelect: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('0 / 100'), findsOneWidget);
      expect(find.textContaining('بيانات غير كافية'), findsNothing);
      expect(find.textContaining('5 / 10'), findsOneWidget);
      expect(find.text('Teacher Zero'), findsOneWidget);
    });

    testWidgets('Case B: weeklyPoints == null hides score row entirely and unavailable interaction is hidden', (tester) async {
      const teacher = TeacherRankingItemModel(
        rank: 1,
        teacherId: 't2',
        fullName: 'Teacher Null',
        weeklyPoints: null,
        components: RankingComponentsModel(
          interaction: ComponentScoreModel(available: false, points: 0, max: 10),
        ),
      );

      await tester.pumpWidget(
        _wrap(
          const TeacherRankingCardContent(
            teacher: teacher,
            selected: false,
            canModify: true,
            canSelect: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('/ 100'), findsNothing);
      expect(find.textContaining('بيانات غير كافية'), findsNothing);
      expect(find.textContaining('نقاط التفاعل'), findsNothing);
      expect(find.text('Teacher Null'), findsOneWidget);
      expect(find.text('+ عناصر التقييم'), findsOneWidget);
      expect(find.text('عرض السجل'), findsOneWidget);
      expect(find.text('إضافة نقاط'), findsOneWidget);
    });
  });

  group('TeacherRankingHeader badge rendering', () {
    testWidgets('insufficient_data does NOT render visible badge', (tester) async {
      const response = TeacherRankingResponse(
        status: 'insufficient_data',
        ranking: [],
      );

      await tester.pumpWidget(
        _wrap(
          TeacherRankingHeader(
            classrooms: const [PlanClassroomOption(id: 'c1', name: 'Class 1')],
            selectedClassroom: const PlanClassroomOption(id: 'c1', name: 'Class 1'),
            onClassroomChanged: (_) {},
            response: response,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StatusBadge), findsNothing);
      expect(find.text('بيانات غير كافية'), findsNothing);
    });

    testWidgets('provisional renders مؤقت badge', (tester) async {
      const response = TeacherRankingResponse(
        status: 'provisional',
        ranking: [],
      );

      await tester.pumpWidget(
        _wrap(
          TeacherRankingHeader(
            classrooms: const [PlanClassroomOption(id: 'c1', name: 'Class 1')],
            selectedClassroom: const PlanClassroomOption(id: 'c1', name: 'Class 1'),
            onClassroomChanged: (_) {},
            response: response,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StatusBadge), findsOneWidget);
      expect(find.text('مؤقت'), findsOneWidget);
    });
  });
}
