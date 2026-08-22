import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/errors/read_evaluations_failure_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo_impl.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _FakeApi api;
  late WeeklyEvaluationsReadRepoImpl repo;

  setUpAll(() => S.load(const Locale('ar')));
  setUp(() {
    api = _FakeApi();
    repo = WeeklyEvaluationsReadRepoImpl(api);
  });

  test('request without week and studentId has no query', () async {
    await repo.getMyEvaluations();
    expect(api.query, isNull);
  });

  test('request sends week only', () async {
    await repo.getMyEvaluations(week: 2);
    expect(api.query, {'week': 2});
  });

  test('request sends trimmed studentId only', () async {
    await repo.getMyEvaluations(studentId: ' child ');
    expect(api.query, {'studentId': 'child'});
  });

  test('request sends week and studentId', () async {
    await repo.getMyEvaluations(week: 3, studentId: 'child');
    expect(api.query, {'week': 3, 'studentId': 'child'});
  });

  test('request sends trimmed classroomId', () async {
    await repo.getMyEvaluations(classroomId: ' classroom ');
    expect(api.query, {'classroomId': 'classroom'});
  });

  test('empty classroomId does not create a query', () async {
    await repo.getMyEvaluations(classroomId: '  ');
    expect(api.query, isNull);
  });

  test('classroom options reuse chat rooms and deduplicate by id', () async {
    api.response = {
      'success': true,
      'data': [
        {'id': 'room-1', 'classroomId': 'general', 'displayName': 'General'},
        {'id': 'room-2', 'classroomId': 'arabic', 'displayName': 'Arabic'},
        {'id': 'room-3', 'classroomId': 'arabic', 'displayName': 'Duplicate'},
        {'id': 'support', 'type': 'support', 'displayName': 'Support'},
      ],
    };

    final result = await repo.getMyClassrooms();
    final classrooms = result.getOrElse(() => throw StateError('failure'));
    expect(api.path, '/chats/rooms');
    expect(classrooms.map((item) => item.id), ['general', 'arabic']);
    expect(classrooms.map((item) => item.name), ['General', 'Arabic']);
  });

  test('empty studentId and null week do not create null query keys', () async {
    await repo.getMyEvaluations(studentId: '  ');
    expect(api.query, isNull);
    expect(api.path, '/student-evaluations/me');
    expect(api.isProtected, isTrue);
  });

  test('one response parses 70 Gulf classrooms with one API call', () async {
    api.response = {
      'success': true,
      'results': 70,
      'data': {
        'mode': 'gulf',
        'classroomsCount': 70,
        'classrooms': List.generate(
          70,
          (index) => {
            'id': 'classroom-$index',
            'subject': {'id': 'subject-$index', 'name': 'Subject $index'},
            'evaluationStatus': 'not_evaluated',
            'evaluation': null,
          },
        ),
        'subjects': <Object>[],
      },
    };

    final result = await repo.getMyEvaluations();
    final response = result.getOrElse(() => throw StateError('failure'));
    expect(api.getCalls, 1);
    expect(response.data.classrooms, hasLength(70));
    expect(api.query, isNull);
    expect(api.query?.containsKey('classroomId') ?? false, isFalse);
  });

  test('access denied is mapped at read repository boundary', () async {
    api.error = const AppException('Access denied');
    final result = await repo.getMyEvaluations(studentId: 'child');
    result.fold(
      (failure) => expect(failure.message, 'غير مصرح بعرض بيانات هذا الطالب'),
      (_) => fail('Expected failure'),
    );
  });

  test('Gulf conflict code is mapped at read repository boundary', () async {
    api.error = const AppException('GULF_CLASSROOM_SUBJECT_DATA_CONFLICT');
    final result = await repo.getMyEvaluations();
    result.fold(
      (failure) => expect(
        failure.message,
        'توجد مشكلة في إعداد مادة الفصل، يرجى التواصل مع الإدارة',
      ),
      (_) => fail('Expected failure'),
    );
  });

  test('409 maps only when the Gulf conflict code is available', () {
    expect(
      ReadEvaluationsFailureMapper.map(
        message: 'Conflict',
        code: ReadEvaluationsFailureMapper.gulfConflictCode,
        statusCode: 409,
      ),
      'توجد مشكلة في إعداد مادة الفصل، يرجى التواصل مع الإدارة',
    );
    expect(
      ReadEvaluationsFailureMapper.map(
        message: 'Another conflict',
        statusCode: 409,
      ),
      'Another conflict',
    );
  });
}

class _FakeApi implements ApiConsumer {
  String path = '';
  Map<String, dynamic>? query;
  bool isProtected = false;
  AppException? error;
  int getCalls = 0;
  Object response = {'success': true, 'data': <String, dynamic>{}};

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    if (error case final error?) throw error;
    getCalls++;
    this.path = path;
    query = queryParameter;
    this.isProtected = isProtected;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
