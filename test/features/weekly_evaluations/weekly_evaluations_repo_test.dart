import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeApi api;
  late WeeklyEvaluationsRepoImpl repo;

  setUp(() {
    api = _FakeApi();
    repo = WeeklyEvaluationsRepoImpl(api);
  });

  test('weekly endpoint sends classroom and selected week', () async {
    await repo.getClassroomWeekly(classroomId: 'classroom', week: 4);
    expect(api.path, '/classrooms/classroom/evaluations/weekly');
    expect(api.query, {'week': 4});
  });

  test('student and one-child requests omit studentId', () async {
    await repo.getMyEvaluations(week: 2);
    expect(api.query, {'week': 2});
    expect(api.query, isNot(contains('studentId')));
  });

  test('multiple-child request includes selected studentId', () async {
    await repo.getMyEvaluations(week: 3, studentId: 'child-2');
    expect(api.query, {'week': 3, 'studentId': 'child-2'});
  });

  test('PUT sends only request contract fields', () async {
    await repo.upsert(
      const UpsertEvaluationRequestModel(
        student: 's',
        classroom: 'c',
        subject: 'x',
        week: 2,
        attendance: 'present',
        participation: 'excellent',
        homework: 'good',
        behavior: 'very_good',
      ),
    );
    final body = api.data as Map<String, dynamic>;
    expect(api.path, '/student-evaluations');
    expect(body['week'], 2);
    expect(body['behavior'], 'very_good');
    expect(body, isNot(contains('weekStart')));
  });
}

class _FakeApi implements ApiConsumer {
  String path = '';
  Map<String, dynamic>? query;
  Object? data;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    query = queryParameter;
    return {'success': true, 'data': <String, dynamic>{}};
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    return {'success': true};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
