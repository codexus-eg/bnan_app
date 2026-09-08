import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo_impl.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/delete_classroom_dialog.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/edit_classroom_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => S.load(const Locale('ar')));

  group('ClassroomsRepoImpl.deleteClassroom', () {
    test('delete sends request to end point with optional reason', () async {
      final fakeApi = _FakeApi();
      final repo = ClassroomsRepoImpl(fakeApi);

      final result = await repo.deleteClassroom('class-123', reason: 'End of year');

      expect(result.isRight(), isTrue);
      expect(fakeApi.deletedPath, EndPoints.deleteClassroom('class-123'));
      expect(fakeApi.deletedData, {'reason': 'End of year'});
      expect(fakeApi.isProtected, isTrue);
    });

    test('delete succeeds without reason', () async {
      final fakeApi = _FakeApi();
      final repo = ClassroomsRepoImpl(fakeApi);

      final result = await repo.deleteClassroom('class-123');

      expect(result.isRight(), isTrue);
      expect(fakeApi.deletedData, isNull);
    });

    test('delete treats alreadyArchived true as success', () async {
      final fakeApi = _FakeApi()..deleteResponse = {'alreadyArchived': true};
      final repo = ClassroomsRepoImpl(fakeApi);

      final result = await repo.deleteClassroom('class-123');
      expect(result.isRight(), isTrue);
    });

    test('delete maps 409 active session to Arabic friendly message', () async {
      final fakeApi = _FakeApi()
        ..error = const AppException(
          'CLASSROOM_HAS_ACTIVE_SESSION',
          statusCode: 409,
          code: 'CLASSROOM_HAS_ACTIVE_SESSION',
        );
      final repo = ClassroomsRepoImpl(fakeApi);

      final result = await repo.deleteClassroom('class-123');
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'لا يمكن حذف الفصل لوجود حصة نشطة حاليًا'),
        (_) => fail('should fail with active session message'),
      );
    });
  });

  group('ClassroomActionsCubit.deleteClassroom', () {
    test('delete emits loading then success', () async {
      final repo = _MockClassroomsRepo();
      final cubit = ClassroomActionsCubit(repo);
      addTearDown(cubit.close);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<DeleteClassroomLoading>(), isA<DeleteClassroomSuccess>()]),
      );

      await cubit.deleteClassroom('class-1', reason: 'cleanup');
      await states;

      expect(repo.deleteCalls, 1);
      expect(repo.deletedId, 'class-1');
      expect(repo.deletedReason, 'cleanup');
    });

    test('delete emits failure on error', () async {
      final repo = _MockClassroomsRepo()
        ..failure = Failure(message: 'Cannot delete');
      final cubit = ClassroomActionsCubit(repo);
      addTearDown(cubit.close);

      final states = expectLater(
        cubit.stream,
        emitsInOrder([isA<DeleteClassroomLoading>(), isA<DeleteClassroomFailure>()]),
      );

      await cubit.deleteClassroom('class-1');
      await states;

      expect((cubit.state as DeleteClassroomFailure).message, 'Cannot delete');
    });
  });

  group('DeleteClassroomDialog Widget Test', () {
    testWidgets('shows confirmation and calls delete with reason', (tester) async {
      final repo = _MockClassroomsRepo();
      final cubit = ClassroomActionsCubit(repo);
      addTearDown(cubit.close);

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
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const DeleteClassroomDialog(
                classroomId: 'class-99',
                classroomName: 'Grade 1A',
              ),
            ),
          ),
        ),
      );

      expect(find.text('حذف الفصل'), findsOneWidget);
      expect(find.textContaining('Grade 1A'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Reason for delete');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'حذف'));
      await tester.pump();

      expect(repo.deleteCalls, 1);
      expect(repo.deletedId, 'class-99');
      expect(repo.deletedReason, 'Reason for delete');
    });
  });

  group('EditClassroomDialog submit logic', () {
    testWidgets('submits trimmed name and omits empty meeting link', (tester) async {
      final repo = _MockClassroomsRepo();
      final cubit = ClassroomActionsCubit(repo);
      addTearDown(cubit.close);

      const classroom = ClassroomModel(
        id: 'class-1',
        name: 'Initial Name',
        curriculum: ClassroomLookupModel(id: 'c1', name: 'Curriculum 1'),
        grade: ClassroomLookupModel(id: 'g1', name: 'Grade 1'),
        teachers: [],
        isActive: true,
        approvedStudentsCount: 0,
        assignedTeachersCount: 0,
        meetingLink: '',
      );

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
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const EditClassroomDialog(classroomItem: classroom),
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'حفظ'));
      await tester.pump();

      expect(repo.updateCalls, 1);
      expect(repo.lastUpdatedModel?.name, 'Initial Name');
      expect(repo.lastUpdatedModel?.meetingLink, isNull);
      expect(repo.lastUpdatedModel?.toJson(), {'name': 'Initial Name'});
    });
  });
}

class _FakeApi implements ApiConsumer {
  String? deletedPath;
  Object? deletedData;
  bool isProtected = false;
  dynamic deleteResponse = {'success': true};
  AppException? error;

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    deletedPath = path;
    deletedData = data;
    this.isProtected = isProtected;
    if (error != null) throw error!;
    return deleteResponse;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockClassroomsRepo implements ClassroomsRepo {
  int deleteCalls = 0;
  String? deletedId;
  String? deletedReason;
  int updateCalls = 0;
  ClassroomRequestModel? lastUpdatedModel;
  Failure? failure;

  @override
  Future<Either<Failure, void>> deleteClassroom(
    String classroomId, {
    String? reason,
  }) async {
    deleteCalls++;
    deletedId = classroomId;
    deletedReason = reason;
    if (failure != null) return Left(failure!);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  ) async {
    updateCalls++;
    lastUpdatedModel = model;
    if (failure != null) return Left(failure!);
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
