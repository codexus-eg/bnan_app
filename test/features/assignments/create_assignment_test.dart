import 'dart:io';

import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/create_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo_impl.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_text_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  group('Task 1 — Assignment Creation Request & Serialization', () {
    test('CreateAssignmentRequestModel serializes totalPoints correctly', () {
      const model = CreateAssignmentRequestModel(
        title: 'Math HW 1',
        description: 'Solve questions 1-5',
        dueDate: '2026-10-28T20:59:59.000Z',
        classroom: '671abc123456789012345678',
        subject: '671def123456789012345678',
        totalPoints: 25,
      );

      final json = model.toJson();
      expect(json['title'], 'Math HW 1');
      expect(json['description'], 'Solve questions 1-5');
      expect(json['dueDate'], '2026-10-28T20:59:59.000Z');
      expect(json['classroom'], '671abc123456789012345678');
      expect(json['subject'], '671def123456789012345678');
      expect(json['totalPoints'], 25);
      expect(json.containsKey('attachment'), isFalse);
    });

    test('AssignmentsRepoImpl constructs multipart request without attachment', () async {
      final fakeApi = _FakeAssignmentApi();
      final repo = AssignmentsRepoImpl(apiConsumer: fakeApi);

      const model = CreateAssignmentRequestModel(
        title: 'Science HW',
        description: 'Read chapter 3',
        dueDate: '2026-10-29T20:59:59.000Z',
        classroom: 'class123',
        subject: 'subj456',
        totalPoints: 10,
      );

      final result = await repo.createAssignment(request: model);
      expect(result.isRight(), isTrue);

      final sentData = fakeApi.lastPostData;
      expect(sentData, isA<FormData>());
      final formData = sentData as FormData;
      final fields = {for (final f in formData.fields) f.key: f.value};

      expect(fields['classroom'], 'class123');
      expect(fields['subject'], 'subj456');
      expect(fields['title'], 'Science HW');
      expect(fields['description'], 'Read chapter 3');
      expect(fields['dueDate'], '2026-10-29T20:59:59.000Z');
      expect(fields['totalPoints'], '10');
      expect(formData.files.isEmpty, isTrue);
    });

    test('AssignmentsRepoImpl constructs multipart request with attachment', () async {
      final fakeApi = _FakeAssignmentApi();
      final repo = AssignmentsRepoImpl(apiConsumer: fakeApi);
      final tempFile = File('${Directory.systemTemp.path}/test_attachment.txt')
        ..writeAsStringSync('sample content');
      addTearDown(() {
        if (tempFile.existsSync()) tempFile.deleteSync();
      });

      final model = CreateAssignmentRequestModel(
        title: 'Science HW with file',
        description: '',
        dueDate: '2026-10-30T20:59:59.000Z',
        classroom: 'class123',
        subject: 'subj456',
        totalPoints: 15,
        attachment: tempFile,
      );

      final result = await repo.createAssignment(request: model);
      expect(result.isRight(), isTrue);

      final formData = fakeApi.lastPostData as FormData;
      expect(formData.files.any((f) => f.key == 'attachment'), isTrue);
      expect(formData.files.firstWhere((f) => f.key == 'attachment').value.filename, 'test_attachment.txt');
    });
  });

  group('Task 1 — Cubit Local Validation & Double Submission Prevention', () {
    test('rejects missing totalPoints locally', () async {
      final cubit = CreateAssignmentCubit(_MockAssignmentsRepo());
      cubit.selectedClassroomId = 'class1';
      cubit.selectedSubjectId = 'sub1';
      cubit.selectedDueDate = DateTime.now().add(const Duration(days: 2)).toIso8601String();
      cubit.titleController.text = 'Title';
      cubit.totalPointsController.text = ''; // Missing

      await cubit.createAssignment();

      expect(cubit.validationMessage, S.current.totalPointsRequired);
      expect(cubit.state, isA<CreateAssignmentChangeValue>());
      await cubit.close();
    });

    test('rejects zero or negative totalPoints locally', () async {
      final cubit = CreateAssignmentCubit(_MockAssignmentsRepo());
      cubit.selectedClassroomId = 'class1';
      cubit.selectedSubjectId = 'sub1';
      cubit.selectedDueDate = DateTime.now().add(const Duration(days: 2)).toIso8601String();
      cubit.titleController.text = 'Title';

      cubit.totalPointsController.text = '0';
      await cubit.createAssignment();
      expect(cubit.validationMessage, S.current.invalidAssignmentTotalPoints);

      cubit.totalPointsController.text = '-5';
      await cubit.createAssignment();
      expect(cubit.validationMessage, S.current.invalidAssignmentTotalPoints);

      await cubit.close();
    });

    test('rejects past due date locally', () async {
      final cubit = CreateAssignmentCubit(_MockAssignmentsRepo());
      cubit.selectedClassroomId = 'class1';
      cubit.selectedSubjectId = 'sub1';
      cubit.titleController.text = 'Title';
      cubit.totalPointsController.text = '10';
      cubit.selectedDueDate = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      await cubit.createAssignment();

      expect(cubit.validationMessage, S.current.invalidDueDate);
      expect(cubit.state, isA<CreateAssignmentChangeValue>());
      await cubit.close();
    });

    test('prevents double submission when request is loading', () async {
      final repo = _SlowMockAssignmentsRepo();
      final cubit = CreateAssignmentCubit(repo);
      cubit.selectedClassroomId = 'class1';
      cubit.selectedSubjectId = 'sub1';
      cubit.selectedDueDate = DateTime.now().add(const Duration(days: 2)).toIso8601String();
      cubit.titleController.text = 'Title';
      cubit.totalPointsController.text = '20';

      final firstCall = cubit.createAssignment();
      expect(cubit.state, isA<CreateAssignmentLoading>());

      // Attempt second submission while loading
      await cubit.createAssignment();
      expect(repo.callCount, 1);

      repo.finish();
      await firstCall;
      expect(cubit.state, isA<CreateAssignmentSuccess>());
      await cubit.close();
    });
  });

  group('Task 1 — Backend Error Mapping in AppException', () {
    test('maps INVALID_ASSIGNMENT_TOTAL_POINTS correctly', () {
      final exception = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 400,
            data: {'code': 'INVALID_ASSIGNMENT_TOTAL_POINTS'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(exception.message, S.current.invalidAssignmentTotalPoints);
    });

    test('maps message "Invalid assignment total points" correctly', () {
      final exception = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 400,
            data: {'message': 'Invalid assignment total points'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(exception.message, S.current.invalidAssignmentTotalPoints);
    });

    test('maps INVALID_DUE_DATE correctly', () {
      final exception = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 400,
            data: {'code': 'INVALID_DUE_DATE'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(exception.message, S.current.invalidDueDate);
    });

    test('maps CLASSROOM_SUBJECT_NOT_FOUND correctly', () {
      final exception = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 404,
            data: {'code': 'CLASSROOM_SUBJECT_NOT_FOUND'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(exception.message, S.current.classroomSubjectNotFound);
    });

    test('maps 401 Unauthorized and 403 Forbidden correctly', () {
      final unauthorized = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(unauthorized.message, S.current.errorUnauthorized);

      final forbidden = AppException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/assignments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/assignments'),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(forbidden.message, S.current.errorForbidden);
    });
  });

  group('Task 1 — Total Points UI Widget Rendering & Localization', () {
    testWidgets('renders Total Points field with Arabic label and validates empty/negative', (tester) async {
      final cubit = CreateAssignmentCubit(_MockAssignmentsRepo());
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: Form(
                key: cubit.formKey,
                child: const SingleChildScrollView(
                  child: CreateAssignmentTextFields(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الدرجة الكلية للواجب'), findsOneWidget);

      cubit.formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال الدرجة الكلية للواجب'), findsOneWidget);

      cubit.totalPointsController.text = '0';
      cubit.formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('الدرجة الكلية للواجب يجب أن تكون أكبر من صفر'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('renders Total Points field with English label and validates empty/negative', (tester) async {
      final cubit = CreateAssignmentCubit(_MockAssignmentsRepo());
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: Form(
                key: cubit.formKey,
                child: const SingleChildScrollView(
                  child: CreateAssignmentTextFields(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Total Points'), findsOneWidget);

      cubit.formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Total points are required'), findsOneWidget);

      cubit.totalPointsController.text = '0';
      cubit.formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Total points must be greater than zero'), findsOneWidget);

      await cubit.close();
    });
  });
}

class _FakeAssignmentApi implements ApiConsumer {
  dynamic lastPostData;

  @override
  Future post(
    String path, {
    data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
    bool isFormData = false,
  }) async {
    lastPostData = data;
    return {
      'data': {
        '_id': 'asg_123',
        'title': 'Test Assignment',
        'classroom': 'class123',
        'subject': 'subj456',
        'dueDate': '2026-10-29T20:59:59.000Z',
        'totalPoints': 10,
      }
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockAssignmentsRepo implements AssignmentsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SlowMockAssignmentsRepo implements AssignmentsRepo {
  int callCount = 0;
  Future<void>? _completer;
  void Function()? _resolver;

  @override
  Future<Either<Failure, AssignmentModel>> createAssignment({required CreateAssignmentRequestModel request}) async {
    callCount++;
    _completer = Future<void>(() async {
      while (_resolver == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
    });
    await _completer;
    return Right(AssignmentModel.fromJson({
      '_id': 'asg_123',
      'title': request.title,
      'classroom': request.classroom,
      'subject': request.subject,
      'dueDate': request.dueDate,
      'totalPoints': request.totalPoints,
    }));
  }

  void finish() {
    _resolver = () {};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
