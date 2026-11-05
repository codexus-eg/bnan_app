import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  group('Task 2 — Weekly Evaluation Role Access Policy', () {
    test('Teacher has canAdd and canEdit, but canSendAll is FALSE', () {
      final policy = WeeklyEvaluationsAccessPolicy.fromRole('teacher');
      expect(policy.canAdd, isTrue);
      expect(policy.canEdit, isTrue);
      expect(policy.canFilterByClassroom, isTrue);
      expect(policy.isReadOnly, isFalse);
      expect(policy.canSendAll, isFalse, reason: 'Teacher must not have bulk send permission');
    });

    test('Supervisor has canAdd, canEdit, and canSendAll is TRUE', () {
      final policy = WeeklyEvaluationsAccessPolicy.fromRole('supervisor');
      expect(policy.canAdd, isTrue);
      expect(policy.canEdit, isTrue);
      expect(policy.canFilterByClassroom, isTrue);
      expect(policy.isReadOnly, isFalse);
      expect(policy.canSendAll, isTrue);
    });

    test('Student and parent are read only and cannot send all', () {
      final student = WeeklyEvaluationsAccessPolicy.fromRole('student');
      expect(student.canAdd, isFalse);
      expect(student.canSendAll, isFalse);
      expect(student.isReadOnly, isTrue);

      final parent = WeeklyEvaluationsAccessPolicy.fromRole('parent');
      expect(parent.canAdd, isFalse);
      expect(parent.canSendAll, isFalse);
      expect(parent.isReadOnly, isTrue);
    });
  });

  group('Task 2 — UI Widget Actions Visibility for Roles', () {
    testWidgets('Teacher sees Create Evaluation and DOES NOT see Send All', (tester) async {
      final teacherPolicy = WeeklyEvaluationsAccessPolicy.fromRole('teacher');

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
            body: WeeklyEvaluationsHeaderActions(
              showSendAll: teacherPolicy.canSendAll,
              onAddPressed: () {},
              onSendAllPressed: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Only 1 AddNewTopicButton rendered for Teacher
      expect(find.byType(AddNewTopicButton), findsOneWidget);
      // Teacher sees "إضافة تقييم جديد"
      expect(find.text(S.current.addNewEvaluation), findsOneWidget);
      // Teacher DOES NOT see "إرسال للكل"
      expect(find.text(S.current.sendAll), findsNothing);
    });

    testWidgets('Supervisor sees both Send All and Create Evaluation', (tester) async {
      final supervisorPolicy = WeeklyEvaluationsAccessPolicy.fromRole('supervisor');

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
            body: WeeklyEvaluationsHeaderActions(
              showSendAll: supervisorPolicy.canSendAll,
              onAddPressed: () {},
              onSendAllPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 2 buttons rendered for Supervisor
      expect(find.byType(AddNewTopicButton), findsNWidgets(2));
      // Supervisor sees both buttons
      expect(find.text(S.current.addNewEvaluation), findsOneWidget);
      expect(find.text(S.current.sendAll), findsOneWidget);
    });
  });

  group('Task 2 — Permission-denied (401/403) Handling', () {
    test('cubit emits EvaluationsPublishFailure when publish is unauthorized (403)', () async {
      final repo = _ForbiddenWeeklyEvaluationsRepo();
      final cubit = WeeklyEvaluationsCubit(repo, _MockAssignmentsRepo());

      cubit.selectedClassroom = const PlanClassroomOption(id: 'c1', name: 'Class 1');
      cubit.selectedWeek = 3;

      final success = await cubit.publishWeeklyEvaluations();
      expect(success, isFalse);
      expect(cubit.state, isA<EvaluationsPublishFailure>());
      final failure = cubit.state as EvaluationsPublishFailure;
      expect(failure.message, S.current.errorForbidden);

      await cubit.close();
    });
  });
}

class _ForbiddenWeeklyEvaluationsRepo implements WeeklyEvaluationsRepo {
  @override
  Future<Either<Failure, Unit>> publishWeeklyEvaluations({
    required String classroomId,
    required int week,
  }) async {
    return Left(Failure(message: S.current.errorForbidden, code: 'FORBIDDEN'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockAssignmentsRepo implements AssignmentsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
