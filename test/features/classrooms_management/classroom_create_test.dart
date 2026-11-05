import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_card.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('one classroom stays content-height in the real list', (
    tester,
  ) async {
    await _pumpClassrooms(tester, [_classroom('1')]);

    expect(_cardHeight(tester, 0), lessThan(300));
    expect(tester.getSize(find.byType(ListView)).height, lessThan(500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('multiple classrooms each stay content-height', (tester) async {
    await _pumpClassrooms(tester, [_classroom('1'), _classroom('2')]);

    expect(_cardHeight(tester, 0), lessThan(300));
    expect(_cardHeight(tester, 1), lessThan(300));
    expect(tester.takeException(), isNull);
  });

  test('create request sends supervisorId and never supervisor', () {
    const request = ClassroomRequestModel(
      name: 'Class A',
      curriculumId: 'curriculum-1',
      gradeId: 'grade-1',
      supervisorId: 'supervisor-1',
    );

    expect(request.toJson(), {
      'name': 'Class A',
      'curriculum': 'curriculum-1',
      'grade': 'grade-1',
      'supervisorId': 'supervisor-1',
    });
    expect(request.toJson(), isNot(contains('supervisor')));
  });

  test('classroom meeting link parsing is backward compatible', () {
    expect(_classroomFromJson({}).meetingLink, isEmpty);
    expect(
      _classroomFromJson({
        'meetingLink': 'https://meet.example/room',
      }).meetingLink,
      'https://meet.example/room',
    );
  });

  test('meeting link is optional and omitted when empty', () {
    expect(
      const ClassroomRequestModel(name: 'A').toJson(),
      isNot(contains('meetingLink')),
    );
    expect(
      const ClassroomRequestModel(name: 'A', meetingLink: '').toJson(),
      isNot(contains('meetingLink')),
    );
    expect(
      const ClassroomRequestModel(
        name: 'A',
        meetingLink: 'https://meet.example/room',
      ).toJson(),
      containsPair('meetingLink', 'https://meet.example/room'),
    );
  });

  test(
    'create forwards selected supervisor and preserves success flow',
    () async {
      final repo = _FakeClassroomsRepo();
      final cubit = ClassroomActionsCubit(repo);
      const request = ClassroomRequestModel(
        name: 'Class A',
        supervisorId: 'supervisor-1',
      );

      await cubit.createClassroom(request);

      expect(repo.lastRequest?.supervisorId, 'supervisor-1');
      expect(cubit.state, isA<CreateClassroomSuccess>());
    },
  );

  test('create ignores repeated submit while request is pending', () async {
    final repo = _FakeClassroomsRepo()..pending = Completer();
    final cubit = ClassroomActionsCubit(repo);
    const request = ClassroomRequestModel(name: 'A', supervisorId: 's1');

    final first = cubit.createClassroom(request);
    final second = cubit.createClassroom(request);
    repo.pending!.complete(const Right(null));
    await Future.wait([first, second]);

    expect(repo.createCalls, 1);
  });

  test(
    'closing classrooms cubit during load does not emit after close',
    () async {
      final repo = _FakeClassroomsRepo()..pendingGet = Completer();
      final cubit = ClassroomsCubit(repo);

      final load = cubit.getClassrooms();
      await cubit.close();
      repo.pendingGet!.complete(Right(_classroomsResponse([_classroom('1')])));

      await expectLater(load, completes);
    },
  );
  testWidgets(
    'curriculum dropdown filters classrooms by curriculum ID and resets on all',
    (tester) async {
      final class1 = ClassroomModel(
        id: '1',
        name: 'Class Egyptian',
        curriculum: const ClassroomLookupModel(id: 'c-egypt', name: 'Egyptian'),
        grade: const ClassroomLookupModel(id: 'g1', name: 'Grade 1'),
        teachers: const [],
        isActive: true,
        approvedStudentsCount: 1,
        assignedTeachersCount: 0,
      );
      final class2 = ClassroomModel(
        id: '2',
        name: 'Class Saudi',
        curriculum: const ClassroomLookupModel(id: 'c-saudi', name: 'Saudi'),
        grade: const ClassroomLookupModel(id: 'g2', name: 'Grade 2'),
        teachers: const [],
        isActive: true,
        approvedStudentsCount: 1,
        assignedTeachersCount: 0,
      );

      await _pumpClassrooms(tester, [class1, class2]);

      // Both classrooms rendered initially
      expect(find.text('Class Egyptian'), findsOneWidget);
      expect(find.text('Class Saudi'), findsOneWidget);

      // Tap Dropdown and select Egyptian
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Egyptian').last);
      await tester.pumpAndSettle();

      expect(find.text('Class Egyptian'), findsOneWidget);
      expect(find.text('Class Saudi'), findsNothing);

      // Select All Curriculums
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text(S.current.allCurriculms).last);
      await tester.pumpAndSettle();

      expect(find.text('Class Egyptian'), findsOneWidget);
      expect(find.text('Class Saudi'), findsOneWidget);
    },
  );
}

Future<void> _pumpClassrooms(
  WidgetTester tester,
  List<ClassroomModel> classrooms,
) async {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final repo = _FakeClassroomsRepo()
    ..response = _classroomsResponse(classrooms);
  final cubit = ClassroomsCubit(repo);
  await cubit.getClassrooms();
  addTearDown(cubit.close);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider(create: (_) => ClassroomActionsCubit(repo)),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(body: ClassroomsManagementBody()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

double _cardHeight(WidgetTester tester, int index) =>
    tester.getSize(find.byType(ClassroomsManagementCard).at(index)).height;

ClassroomModel _classroom(String id) => ClassroomModel(
  id: id,
  name: 'Class $id',
  curriculum: const ClassroomLookupModel(id: 'c', name: 'Gulf'),
  grade: const ClassroomLookupModel(id: 'g', name: 'Grade 1'),
  teachers: const [],
  isActive: true,
  approvedStudentsCount: 1,
  assignedTeachersCount: 0,
);

ClassroomModel _classroomFromJson(Map<String, dynamic> values) =>
    ClassroomModel.fromJson({
      'id': 'classroom',
      'name': 'Classroom',
      'curriculum': <String, dynamic>{},
      'grade': <String, dynamic>{},
      ...values,
    });

ClassroomsResponseModel _classroomsResponse(List<ClassroomModel> data) =>
    ClassroomsResponseModel(
      success: true,
      results: data.length,
      pagination: ClassroomsPaginationModel(
        currentPage: 1,
        perPage: 20,
        total: data.length,
        lastPage: 1,
      ),
      data: data,
    );

class _FakeClassroomsRepo implements ClassroomsRepo {
  int createCalls = 0;
  ClassroomRequestModel? lastRequest;
  Completer<Either<Failure, void>>? pending;
  Completer<Either<Failure, ClassroomsResponseModel>>? pendingGet;
  ClassroomsResponseModel? response;

  @override
  Future<Either<Failure, void>> createClassroom(ClassroomRequestModel model) {
    createCalls++;
    lastRequest = model;
    return pending?.future ?? Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
    String? keyword,
  }) =>
      pendingGet?.future ?? Future.value(Right(response!));
  @override
  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(
    String classroomId,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, void>> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, void>> deleteClassroom(
    String classroomId, {
    String? reason,
  }) => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
