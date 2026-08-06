import 'dart:async';

import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/parent_schedule_view.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_model.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';
import 'fake_parent_schedule_repos.dart';

void main() {
  late FakeParentScheduleChildrenRepo childrenRepo;
  late FakeParentEgyptianScheduleRepo egyptianRepo;
  late FakeGulfScheduleRepo gulfRepo;

  setUp(() {
    childrenRepo = FakeParentScheduleChildrenRepo(
      () async =>
          const Right(GetParentChildrenResponseModel(data: _mixedChildren)),
    );
    egyptianRepo = FakeParentEgyptianScheduleRepo(
      (_) async => Right(_egyptianSuccess()),
    );
    gulfRepo = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    );
    _register(childrenRepo, egyptianRepo, gulfRepo);
  });

  tearDown(() => getIt.reset());

  testWidgets('auto-selects first child and switches one endpoint at a time', (
    tester,
  ) async {
    await _pump(tester);

    expect(egyptianRepo.studentIds, ['egypt-id']);
    expect(gulfRepo.studentIds, isEmpty);
    expect(find.byType(NetworkAttachmentPreview), findsOneWidget);

    await _selectChild(tester, 'Gulf Child');
    expect(egyptianRepo.studentIds, ['egypt-id']);
    expect(gulfRepo.studentIds, ['gulf-id']);
    expect(find.byType(NetworkAttachmentPreview), findsNothing);
    expect(find.byType(LessonsManagementBody), findsOneWidget);
    expect(find.byType(AddNewTopicButton), findsNothing);
    final gulfCubit = tester
        .element(find.byType(LessonsManagementBody))
        .read<GulfScheduleCubit>();
    expect(gulfCubit.canManage, isFalse);
    expect(await gulfCubit.saveEntry(day: 'sunday', startTime: '09:00'), false);
    expect(gulfRepo.lastOperation, isNull);

    await _selectChild(tester, 'Egyptian Child');
    expect(egyptianRepo.studentIds, ['egypt-id', 'egypt-id']);
    expect(gulfRepo.studentIds, ['gulf-id']);
    expect(find.byType(NetworkAttachmentPreview), findsOneWidget);
  });

  testWidgets('null mode and no children call no schedule endpoint', (
    tester,
  ) async {
    childrenRepo.load = () async => const Right(
      GetParentChildrenResponseModel(
        data: [ParentChildModel(id: 'null-id', fullName: 'Null Child')],
      ),
    );
    await _pump(tester);
    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(egyptianRepo.studentIds, isEmpty);
    expect(gulfRepo.studentIds, isEmpty);

    childrenRepo.load = () async =>
        const Right(GetParentChildrenResponseModel());
    await tester.pumpWidget(const SizedBox());
    await _pump(tester);
    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(egyptianRepo.studentIds, isEmpty);
    expect(gulfRepo.studentIds, isEmpty);
  });

  for (final mode in RegistrationMode.values) {
    testWidgets('empty child id blocks ${mode.name} schedule requests', (
      tester,
    ) async {
      childrenRepo.load = () async => Right(
        GetParentChildrenResponseModel(
          data: [
            ParentChildModel(
              id: '   ',
              fullName: 'Invalid Child',
              registrationMode: mode,
            ),
          ],
        ),
      );
      await _pump(tester);

      expect(find.byType(NoDataWidget), findsOneWidget);
      expect(find.byKey(const Key('egyptianSchedulesRetry')), findsNothing);
      expect(egyptianRepo.studentIds, isEmpty);
      expect(gulfRepo.studentIds, isEmpty);
    });
  }

  testWidgets('userId never replaces an empty child id', (tester) async {
    final child = ParentChildModel.fromJson({
      'id': '',
      'userId': 'student-user-id',
      'registrationMode': 'egyptian',
    });
    childrenRepo.load = () async =>
        Right(GetParentChildrenResponseModel(data: [child]));
    await _pump(tester);

    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(egyptianRepo.studentIds, isEmpty);
    expect(gulfRepo.studentIds, isEmpty);
  });

  testWidgets('retry repeats the current Egyptian child only', (tester) async {
    var calls = 0;
    egyptianRepo.load = (_) async => calls++ == 0
        ? Left(Failure(message: 'Unavailable'))
        : const Right(EgyptianSchedulesResponseModel());
    await _pump(tester);

    await tester.tap(find.byKey(const Key('egyptianSchedulesRetry')));
    await tester.pumpAndSettle();
    expect(egyptianRepo.studentIds, ['egypt-id', 'egypt-id']);
    expect(gulfRepo.studentIds, isEmpty);
  });

  testWidgets('children failure retries only the children request', (
    tester,
  ) async {
    var calls = 0;
    childrenRepo.load = () async => calls++ == 0
        ? Left(Failure(message: 'Children unavailable'))
        : const Right(GetParentChildrenResponseModel());
    await _pump(tester);

    await tester.tap(find.byKey(const Key('egyptianSchedulesRetry')));
    await tester.pumpAndSettle();
    expect(childrenRepo.calls, 2);
    expect(egyptianRepo.studentIds, isEmpty);
    expect(gulfRepo.studentIds, isEmpty);
  });

  testWidgets('Gulf retry keeps the selected child id', (tester) async {
    childrenRepo.load = () async =>
        Right(GetParentChildrenResponseModel(data: [_mixedChildren[1]]));
    gulfRepo.loadFailure = Failure(message: 'Gulf unavailable');
    await _pump(tester);

    gulfRepo.loadFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(gulfRepo.studentIds, ['gulf-id', 'gulf-id']);
    expect(egyptianRepo.studentIds, isEmpty);
  });

  testWidgets('late Egyptian result cannot replace selected Gulf content', (
    tester,
  ) async {
    final lateResult =
        Completer<Either<Failure, EgyptianSchedulesResponseModel>>();
    egyptianRepo.load = (_) => lateResult.future;
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.pump();

    await _selectChild(tester, 'Gulf Child');
    expect(find.byType(LessonsManagementBody), findsOneWidget);
    lateResult.complete(Right(_egyptianSuccess()));
    await tester.pumpAndSettle();

    expect(find.byType(LessonsManagementBody), findsOneWidget);
    expect(find.byType(NetworkAttachmentPreview), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('late Gulf result cannot replace selected Egyptian content', (
    tester,
  ) async {
    final lateResult = Completer<Either<Failure, GulfSchedulesResponse>>();
    gulfRepo.queuedLoads.add(lateResult);
    await _pump(tester);

    await _selectChildWithoutSettling(tester, 'Gulf Child');
    await _selectChild(tester, 'Egyptian Child');
    expect(find.byType(NetworkAttachmentPreview), findsOneWidget);

    lateResult.complete(
      const Right(
        GulfSchedulesResponse(
          success: true,
          data: GulfSchedulesData(classrooms: []),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NetworkAttachmentPreview), findsOneWidget);
    expect(find.byType(LessonsManagementBody), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

const _mixedChildren = [
  ParentChildModel(
    id: 'egypt-id',
    fullName: 'Egyptian Child',
    registrationMode: RegistrationMode.egyptian,
  ),
  ParentChildModel(
    id: 'gulf-id',
    fullName: 'Gulf Child',
    registrationMode: RegistrationMode.gulf,
  ),
];

EgyptianSchedulesResponseModel _egyptianSuccess() =>
    const EgyptianSchedulesResponseModel(
      schedules: [
        EgyptianScheduleModel(
          id: 'schedule-id',
          image: 'https://api.example.com/schedule.jpg',
        ),
      ],
    );

void _register(
  ParentHomeRepo parent,
  TableManagementRepo egyptian,
  GulfScheduleRepo gulf,
) {
  getIt.registerSingleton<ParentHomeRepo>(parent);
  getIt.registerSingleton<TableManagementRepo>(egyptian);
  getIt.registerSingleton<GulfScheduleRepo>(gulf);
  getIt.registerFactory(() => GetParentChildrenCubit(parent));
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pumpAndSettle();
}

Widget _app() => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: const ParentScheduleView(),
);

Future<void> _selectChild(WidgetTester tester, String name) async {
  await _selectChildWithoutSettling(tester, name);
  await tester.pumpAndSettle();
}

Future<void> _selectChildWithoutSettling(
  WidgetTester tester,
  String name,
) async {
  await tester.tap(find.byKey(const Key('parentScheduleChildDropdown')));
  await tester.pump();
  await tester.tap(find.text(name).last);
  await tester.pump();
}
