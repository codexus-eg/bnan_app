import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plan_date_field.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_dialog.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_management_body.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_parent_body.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_view_body.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_dialog.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/data/repo/student_groups_repo/student_groups_repo.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_cubit.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/classroom_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/get_teacher_assigned_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subject_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subjects_data_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/plans/presentation/views/plans_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PlansViewBody chooses management flow for non-parent roles', (
    tester,
  ) async {
    await _pumpPlans(tester, 'teacher');

    expect(find.byType(PlansManagementBody), findsOneWidget);
    expect(find.byType(PlansParentBody), findsNothing);
  });

  testWidgets('PlansViewBody chooses parent flow for the parent role', (
    tester,
  ) async {
    await _pumpParentPlansBody(tester);

    expect(find.byType(PlansParentBody), findsOneWidget);
    expect(find.byType(PlansManagementBody), findsNothing);
  });

  testWidgets('initial classrooms state keeps filters and table visible', (
    tester,
  ) async {
    await _pumpPlans(tester, 'teacher', startClassrooms: false, settle: false);

    final context = tester.element(find.byType(PlansView));
    expect(find.text(S.of(context).loadingClassrooms), findsOneWidget);
    expect(find.byType(CustomDropdown), findsNWidgets(2));
    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.text('Sunday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('current week loading keeps the same table structure', (
    tester,
  ) async {
    final repo = _PlansRepo()
      ..weeklyCompleter =
          Completer<Either<Failure, WeeklyPlansResponseModel>>();
    await _pumpPlans(tester, 'teacher', plansRepo: repo, settle: false);

    expect(repo.weekRequests.single, ('classroom', 2));
    expect(find.text('Week 2'), findsOneWidget);
    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.text('Sunday'), findsOneWidget);
    expect(tester.takeException(), isNull);

    repo.weeklyCompleter!.complete(Right(_weeklyResponse(2)));
    await tester.pumpAndSettle();
  });

  testWidgets('no available weeks does not load a weekly plan', (tester) async {
    final repo = _PlansRepo()
      ..elapsedResponses['classroom'] = const ElapsedWeeksResponseModel();

    await _pumpPlans(tester, 'teacher', plansRepo: repo);

    expect(repo.weekRequests, isEmpty);
    expect(find.text('Week 1'), findsNothing);
    expect(find.text('Week 2'), findsNothing);
  });

  testWidgets('empty week keeps headers and day rows visible', (tester) async {
    final repo = _PlansRepo()
      ..weeklyResult = const Right(WeeklyPlansResponseModel());
    await _pumpPlans(tester, 'teacher', plansRepo: repo);

    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.byType(CustomTableRow), findsWidgets);
    expect(find.text('Sunday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('week failure keeps table and shows retry', (tester) async {
    final repo = _PlansRepo()
      ..weeklyResult = Left(Failure(message: 'Week failed'));
    await _pumpPlans(tester, 'teacher', plansRepo: repo);

    expect(find.text('Week failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.text('Sunday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('student sees the read-only responsive view', (tester) async {
    final repo = _PlansRepo();
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpPlans(tester, 'student', plansRepo: repo);

    expect(find.text('Daily Plans'), findsOneWidget);
    expect(find.text('Add a daily plan for students'), findsNothing);
    expect(find.text('Upload study plan'), findsNothing);
    expect(find.text('ليس لديك صلاحية لتنفيذ هذا الإجراء'), findsNothing);
    expect(repo.dailyRequests, isEmpty);
    expect(repo.uploadRequests, isEmpty);
    expect(find.text('Grade'), findsNothing);
    expect(find.byType(CustomTableContainer), findsOneWidget);
    expect(find.byType(CustomTableRow), findsWidgets);
    expect(find.byType(CustomTableCell), findsWidgets);
    expect(find.text('Week 2'), findsOneWidget);
    expect(find.text('Thursday'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final role in ['teacher', 'supervisor', 'admin']) {
    testWidgets('$role sees the allowed management actions', (tester) async {
      await _pumpPlans(tester, role);

      expect(find.text('Add a daily plan for students'), findsOneWidget);
      expect(find.text('Upload study plan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('plans table supports Arabic RTL at 360px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpPlans(tester, 'student', locale: const Locale('ar'));

    expect(find.text('الخميس'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supervisor add dialog includes teacher selector', (
    tester,
  ) async {
    await _pumpPlans(tester, 'supervisor');
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher add dialog omits teacher selector', (tester) async {
    await _pumpPlans(tester, 'teacher');
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();

    expect(find.text('Select teacher'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing week loads the selected classroom week', (
    tester,
  ) async {
    final repo = _PlansRepo();
    await _pumpPlans(tester, 'teacher', plansRepo: repo);

    await tester.tap(find.text('Week 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Week 3').last);
    await tester.pumpAndSettle();

    expect(repo.weekRequests.last, ('classroom', 3));
    expect(find.text('Week 3'), findsOneWidget);
  });

  testWidgets('changing classroom uses its current week once', (tester) async {
    final repo = _PlansRepo()
      ..elapsedResponses.addAll({
        'classroom-a': const ElapsedWeeksResponseModel(
          data: ElapsedWeeksDataModel(weeksCount: 4, currentWeek: 2),
        ),
        'classroom-b': const ElapsedWeeksResponseModel(
          data: ElapsedWeeksDataModel(weeksCount: 4, currentWeek: 3),
        ),
      });
    await _pumpPlans(
      tester,
      'teacher',
      plansRepo: repo,
      teacherClassrooms: const [
        TeacherClassroomModel(id: 'classroom-a', name: 'Class A'),
        TeacherClassroomModel(id: 'classroom-b', name: 'Class B'),
      ],
    );

    await tester.tap(find.text('Class A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Class B').last);
    await tester.pumpAndSettle();

    expect(repo.elapsedRequests, ['classroom-a', 'classroom-b']);
    expect(repo.weekRequests, [('classroom-a', 2), ('classroom-b', 3)]);
    expect(find.text('Week 3'), findsOneWidget);
  });

  testWidgets('daily plan success refreshes the same classroom and week', (
    tester,
  ) async {
    final repo = _PlansRepo();
    await _pumpPlans(tester, 'teacher', plansRepo: repo);
    await _selectWeek(tester, 3);

    await _openAndFillDailyPlan(tester);
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();

    final call = repo.dailyRequests.single;
    expect(call.$1, 'classroom');
    expect(call.$2, 'math');
    expect(call.$3.day, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(call.$3.sessionContent, 'New lesson');
    expect(call.$3.sessionAssignment, 'New homework');
    expect(find.byType(AddDailyPlanDialog), findsNothing);
    expect(find.text('Daily plan added successfully'), findsOneWidget);
    expect(repo.weekRequests.last, ('classroom', 3));
    expect(find.text('Week 3'), findsOneWidget);
  });

  testWidgets('daily duplicate stays inline and retries successfully', (
    tester,
  ) async {
    const duplicate = 'تمت إضافة خطة لهذه المادة في هذا اليوم مسبقًا';
    final repo = _PlansRepo()
      ..dailyResult = Left(Failure(message: '  قيمة مكررة  '));
    await _pumpPlans(tester, 'teacher', plansRepo: repo);
    final requestsBefore = repo.weekRequests.length;

    await _openAndFillDailyPlan(tester);
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AddDailyPlanDialog),
        matching: find.text('The plan has already been uploaded for this day.'),
      ),
      findsOneWidget,
    );
    expect(find.text(duplicate), findsNothing);
    expect(find.text('قيمة مكررة'), findsNothing);
    expect(find.text('New lesson'), findsOneWidget);
    expect(find.text('New homework'), findsOneWidget);
    expect(repo.weekRequests.length, requestsBefore);

    repo.dailyResult = const Right(CreatePlanResponseModel());
    await tester.enterText(find.byType(TextFormField).at(1), 'Changed lesson');
    await tester.ensureVisible(find.text('Add').last);
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();

    expect(repo.dailyRequests, hasLength(2));
    expect(repo.dailyRequests.last.$3.sessionContent, 'Changed lesson');
    expect(find.byType(AddDailyPlanDialog), findsNothing);
    expect(repo.weekRequests.length, requestsBefore + 1);
  });

  testWidgets('daily add ignores a second tap while loading', (tester) async {
    final repo = _PlansRepo()
      ..dailyCompleter = Completer<Either<Failure, CreatePlanResponseModel>>();
    await _pumpPlans(tester, 'teacher', plansRepo: repo);
    await _openAndFillDailyPlan(tester);

    await tester.tap(find.text('Add').last);
    await tester.pump();
    final addButton = find.descendant(
      of: find.byType(AddDailyPlanDialog),
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(addButton);
    await tester.pump();
    expect(repo.dailyRequests, hasLength(1));

    repo.dailyCompleter!.complete(const Right(CreatePlanResponseModel()));
    await tester.pumpAndSettle();
    expect(find.byType(AddDailyPlanDialog), findsNothing);
  });

  testWidgets('daily plan date picker allows yesterday and blocks future', (
    tester,
  ) async {
    final repo = _PlansRepo();
    await _pumpPlans(tester, 'teacher', plansRepo: repo);
    await tester.tap(find.text('Add a daily plan for students'));
    await tester.pumpAndSettle();
    final subjectDropdown = find.byType(CustomDropdown).last;
    await tester.ensureVisible(subjectDropdown);
    await tester.tap(subjectDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Math').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PlanDateField));
    await tester.pumpAndSettle();
    final now = DateUtils.dateOnly(DateTime.now());
    final yesterday = now.subtract(const Duration(days: 1));
    final picker = tester.widget<DatePickerDialog>(
      find.byType(DatePickerDialog),
    );
    expect(picker.lastDate, now);
    expect(picker.firstDate, DateTime(now.year - 1, now.month, now.day));
    if (yesterday.month != now.month || yesterday.year != now.year) {
      await tester.tap(find.byIcon(Icons.chevron_left).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('${yesterday.day}').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final fieldContext = tester.element(find.byType(PlanDateField));
    final displayedDate = MaterialLocalizations.of(
      fieldContext,
    ).formatShortDate(yesterday);
    expect(find.text(displayedDate), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'Old lesson');
    await tester.enterText(find.byType(TextFormField).at(2), 'Old homework');
    await tester.ensureVisible(find.text('Add').last);
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();

    expect(repo.dailyRequests.single.$3.day, _dateOnly(yesterday));
  });

  testWidgets('term upload has real classroom subject and file fields', (
    tester,
  ) async {
    await _pumpPlans(
      tester,
      'teacher',
      teacherClassrooms: const [
        TeacherClassroomModel(id: 'classroom-a', name: 'Class A'),
        TeacherClassroomModel(id: 'classroom-b', name: 'Class B'),
      ],
    );
    await tester.tap(find.text('Upload study plan'));
    await tester.pumpAndSettle();

    final dialog = find.byType(UploadStudyPlanDialog);
    final dropdowns = find.descendant(
      of: dialog,
      matching: find.byType(DropdownButton<String>),
    );
    expect(dropdowns, findsNWidgets(2));
    expect(
      find.descendant(of: dialog, matching: find.byType(CustomFilePickerField)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('Week')),
      findsNothing,
    );
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Math').last);
    await tester.pumpAndSettle();
    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Class B').last);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: dialog, matching: find.text('Math')),
      findsNothing,
    );
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    expect(find.text('Science').last, findsOneWidget);
  });

  testWidgets(
    'term upload validates retries and refreshes selected classroom',
    (tester) async {
      const failureMessage = 'Term upload failed';
      final repo = _PlansRepo()
        ..uploadResult = Left(Failure(message: failureMessage));
      final file = File(r'C:\plans\term-plan.pdf');
      await _pumpPlans(
        tester,
        'teacher',
        plansRepo: repo,
        uploadFilePicker: () async => file,
      );
      await _openUploadAndSelectSubject(tester);

      await tester.tap(find.text('Upload').last);
      await tester.pump();
      expect(find.text('Plan file is required'), findsOneWidget);
      expect(repo.uploadRequests, isEmpty);

      await tester.tap(find.byType(CustomFilePickerField));
      await tester.pumpAndSettle();
      expect(find.text('term-plan.pdf'), findsOneWidget);
      await tester.tap(find.text('Upload').last);
      await tester.pumpAndSettle();

      expect(repo.uploadRequests.single, ('classroom', 'math', file.path));
      expect(
        find.descendant(
          of: find.byType(UploadStudyPlanDialog),
          matching: find.text(failureMessage),
        ),
        findsOneWidget,
      );
      expect(find.text('term-plan.pdf'), findsOneWidget);

      repo.uploadResult = const Right(CreatePlanResponseModel());
      await tester.tap(find.text('Upload').last);
      await tester.pumpAndSettle();

      expect(repo.uploadRequests, hasLength(2));
      expect(find.byType(UploadStudyPlanDialog), findsNothing);
      expect(find.text('Term plan uploaded successfully'), findsOneWidget);
      expect(repo.termRequests.single, 'classroom');
    },
  );

  testWidgets('term upload ignores a second tap while loading', (tester) async {
    final repo = _PlansRepo()
      ..uploadCompleter = Completer<Either<Failure, CreatePlanResponseModel>>();
    await _pumpPlans(
      tester,
      'teacher',
      plansRepo: repo,
      uploadFilePicker: () async => File(r'C:\plans\term.pdf'),
    );
    await _openUploadAndSelectSubject(tester);
    await tester.tap(find.byType(CustomFilePickerField));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Upload').last);
    await tester.pump();
    final uploadButton = find.descendant(
      of: find.byType(UploadStudyPlanDialog),
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(uploadButton);
    await tester.pump();
    expect(repo.uploadRequests, hasLength(1));

    repo.uploadCompleter!.complete(const Right(CreatePlanResponseModel()));
    await tester.pumpAndSettle();
    expect(find.byType(UploadStudyPlanDialog), findsNothing);
  });
}

Future<void> _pumpParentPlansBody(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider(
        create: (_) => GetParentPlansCubit(_PlansRepo()),
        child: PlansViewBody(
          policy: PlansAccessPolicy.fromRole('parent'),
          showEmpty: false,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

String _dateOnly(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

Future<void> _selectWeek(WidgetTester tester, int week) async {
  await tester.tap(find.text('Week 2'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Week $week').last);
  await tester.pumpAndSettle();
}

Future<void> _openAndFillDailyPlan(WidgetTester tester) async {
  await tester.tap(find.text('Add a daily plan for students'));
  await tester.pumpAndSettle();
  final subjectDropdown = find.byType(CustomDropdown).last;
  await tester.ensureVisible(subjectDropdown);
  await tester.tap(subjectDropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Math').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(PlanDateField));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(1), 'New lesson');
  await tester.enterText(find.byType(TextFormField).at(2), 'New homework');
  await tester.ensureVisible(find.text('Add').last);
}

Future<void> _openUploadAndSelectSubject(WidgetTester tester) async {
  await tester.tap(find.text('Upload study plan'));
  await tester.pumpAndSettle();
  final subject = find
      .descendant(
        of: find.byType(UploadStudyPlanDialog),
        matching: find.byType(DropdownButton<String>),
      )
      .last;
  await tester.tap(subject);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Math').last);
  await tester.pumpAndSettle();
}

Future<void> _pumpPlans(
  WidgetTester tester,
  String role, {
  Locale locale = const Locale('en'),
  _PlansRepo? plansRepo,
  List<TeacherClassroomModel>? teacherClassrooms,
  PlansFilePicker? uploadFilePicker,
  bool startClassrooms = true,
  bool settle = true,
}) async {
  FlutterSecureStorage.setMockInitialValues({});
  await SessionManager.instance.saveSession(
    accessToken: 'test-access-token',
    refreshToken: 'test-refresh-token',
    userRole: role,
  );
  final assignmentsRepo = _AssignmentsRepo(classrooms: teacherClassrooms);
  final classroomsRepo = _ClassroomsRepo();
  final plansView = switch (role) {
    'teacher' => BlocProvider(
      create: (_) {
        final cubit = GetTeacherClassroomsCubit(assignmentsRepo);
        if (startClassrooms) cubit.getMyClassrooms();
        return cubit;
      },
      child: PlansView(uploadFilePicker: uploadFilePicker),
    ),
    'supervisor' => BlocProvider(
      create: (_) {
        final cubit = GetSupervisorClassroomsCubit(_SupervisorRepo());
        if (startClassrooms) cubit.getMyClassrooms();
        return cubit;
      },
      child: PlansView(uploadFilePicker: uploadFilePicker),
    ),
    'admin' => BlocProvider(
      create: (_) {
        final cubit = ClassroomsCubit(classroomsRepo);
        if (startClassrooms) cubit.getClassrooms();
        return cubit;
      },
      child: PlansView(uploadFilePicker: uploadFilePicker),
    ),
    _ => BlocProvider(
      create: (_) {
        final cubit = GetMyEnrollmentsCubit(_StudentGroupsRepo());
        if (startClassrooms) cubit.getMyEnrollments();
        return cubit;
      },
      child: PlansView(uploadFilePicker: uploadFilePicker),
    ),
  };
  final resolvedPlansRepo = plansRepo ?? _PlansRepo();
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GetElapsedWeeksCubit(resolvedPlansRepo)),
          BlocProvider(create: (_) => GetWeeklyPlansCubit(resolvedPlansRepo)),
          BlocProvider(create: (_) => GetTermPlansCubit(resolvedPlansRepo)),
          BlocProvider(create: (_) => PlansActionsCubit(resolvedPlansRepo)),
          BlocProvider(
            create: (_) => GetClassroomSubjectsCubit(assignmentsRepo),
          ),
          BlocProvider(
            create: (_) => GetTeacherAssignedSubjectsCubit(assignmentsRepo),
          ),
          BlocProvider(create: (_) => ClassroomDetailsCubit(classroomsRepo)),
        ],
        child: plansView,
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    for (var index = 0; index < 5; index++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }
}

class _StudentGroupsRepo implements StudentGroupsRepo {
  @override
  Future<Either<Failure, StudentEnrollmentsResponseModel>>
  getMyEnrollments() async => Right(
    const StudentEnrollmentsResponseModel(
      enrollments: [
        StudentEnrollmentModel(
          id: 'enrollment',
          classroom: EnrollmentClassroomModel(id: 'classroom', name: 'Class A'),
          status: 'approved',
          joinedAt: '',
          createdAt: '',
          updatedAt: '',
        ),
      ],
    ),
  );
}

class _SupervisorRepo implements SupervisorManagementRepo {
  @override
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms() async => Right(
    const GetSupervisorClassroomsResponseModel(
      data: [SupervisorClassroomModel(id: 'classroom', name: 'Class A')],
    ),
  );
}

class _AssignmentsRepo implements AssignmentsRepo {
  _AssignmentsRepo({List<TeacherClassroomModel>? classrooms})
    : classrooms =
          classrooms ??
          const [TeacherClassroomModel(id: 'classroom', name: 'Class A')];

  final List<TeacherClassroomModel> classrooms;

  @override
  Future<Either<Failure, TeacherClassroomsResponseModel>>
  getMyClassrooms() async =>
      Right(TeacherClassroomsResponseModel(classrooms: classrooms));

  @override
  Future<Either<Failure, ClassroomSubjectsResponseModel>> getClassroomSubjects({
    required String classroomId,
  }) async => const Right(
    ClassroomSubjectsResponseModel(
      subjects: [SubjectDetailsModel(id: 'math', name: 'Math')],
    ),
  );

  @override
  Future<Either<Failure, GetTeacherAssignedSubjectsResponseModel>>
  getTeacherAssignedSubjects({required String classroomId}) async => Right(
    GetTeacherAssignedSubjectsResponseModel(
      success: true,
      results: 1,
      data: TeacherAssignedSubjectsDataModel(
        classroom: null,
        subjects: [
          TeacherAssignedSubjectModel(
            classroomSubjectId: '$classroomId-subject',
            id: classroomId == 'classroom-b' ? 'science' : 'math',
            name: classroomId == 'classroom-b' ? 'Science' : 'Math',
          ),
        ],
      ),
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ClassroomsRepo implements ClassroomsRepo {
  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms() async =>
      Right(
        ClassroomsResponseModel(
          success: true,
          results: 1,
          pagination: const ClassroomsPaginationModel(
            currentPage: 1,
            perPage: 10,
            total: 1,
            lastPage: 1,
          ),
          data: [
            ClassroomModel(
              id: 'classroom',
              name: 'Class A',
              curriculum: const ClassroomLookupModel(
                id: 'curriculum',
                name: '',
              ),
              grade: const ClassroomLookupModel(id: 'grade', name: ''),
              teachers: const [],
              isActive: true,
              approvedStudentsCount: 0,
              assignedTeachersCount: 0,
            ),
          ],
        ),
      );

  @override
  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(
    String classroomId,
  ) async => Right(
    ClassroomDetailsResponseModel(
      success: true,
      data: ClassroomModel(
        id: classroomId,
        name: 'Class A',
        curriculum: const ClassroomLookupModel(id: 'curriculum', name: ''),
        grade: const ClassroomLookupModel(id: 'grade', name: ''),
        teachers: const [
          ClassroomTeacherModel(id: 'teacher', fullName: 'Teacher One'),
        ],
        isActive: true,
        approvedStudentsCount: 0,
        assignedTeachersCount: 1,
      ),
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PlansRepo implements PlansRepo {
  final List<(String, int?)> weekRequests = [];
  final List<String> elapsedRequests = [];
  final List<(String, String, CreateDailyPlanRequestModel)> dailyRequests = [];
  final List<(String, String, String)> uploadRequests = [];
  final List<String> termRequests = [];
  Either<Failure, CreatePlanResponseModel> dailyResult = const Right(
    CreatePlanResponseModel(),
  );
  Either<Failure, CreatePlanResponseModel> uploadResult = const Right(
    CreatePlanResponseModel(),
  );
  Completer<Either<Failure, CreatePlanResponseModel>>? uploadCompleter;
  Completer<Either<Failure, CreatePlanResponseModel>>? dailyCompleter;
  Completer<Either<Failure, WeeklyPlansResponseModel>>? weeklyCompleter;
  final Map<String, ElapsedWeeksResponseModel> elapsedResponses = {};
  Either<Failure, WeeklyPlansResponseModel> weeklyResult = Right(
    _weeklyResponse(2),
  );

  @override
  Future<Either<Failure, CreatePlanResponseModel>> createDailyPlan({
    required String classroomId,
    required String subjectId,
    required CreateDailyPlanRequestModel request,
  }) {
    dailyRequests.add((classroomId, subjectId, request));
    return dailyCompleter?.future ?? Future.value(dailyResult);
  }

  @override
  Future<Either<Failure, ElapsedWeeksResponseModel>> getElapsedWeeks({
    required String classroomId,
  }) async {
    elapsedRequests.add(classroomId);
    return Right(
      elapsedResponses[classroomId] ??
          const ElapsedWeeksResponseModel(
            data: ElapsedWeeksDataModel(weeksCount: 3, currentWeek: 2),
          ),
    );
  }

  @override
  Future<Either<Failure, TermPlansResponseModel>> getTermPlans({
    required String classroomId,
  }) async {
    termRequests.add(classroomId);
    return const Right(TermPlansResponseModel());
  }

  @override
  Future<Either<Failure, CreatePlanResponseModel>> uploadTermPlan({
    required String classroomId,
    required String subjectId,
    required String attachmentPath,
  }) {
    uploadRequests.add((classroomId, subjectId, attachmentPath));
    return uploadCompleter?.future ?? Future.value(uploadResult);
  }

  @override
  Future<Either<Failure, WeeklyPlansResponseModel>> getPlansByWeek({
    required String classroomId,
    int? week,
  }) {
    weekRequests.add((classroomId, week));
    return weeklyCompleter?.future ?? Future.value(weeklyResult);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

WeeklyPlansResponseModel _weeklyResponse(int week) => WeeklyPlansResponseModel(
  data: WeeklyPlansDataModel(
    classroom: const PlanClassroomModel(id: 'classroom', name: 'Class A'),
    week: week,
    subjects: const [
      WeeklyPlanSubjectModel(
        id: 'math',
        name: 'Math',
        plans: [
          DailyPlanItemModel(
            day: 'Sunday',
            sessionContent: 'Lesson',
            sessionAssignment: 'Homework',
          ),
        ],
      ),
    ],
  ),
);
