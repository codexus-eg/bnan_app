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

  test('roster studentId is used in the student subjects endpoint', () async {
    api.response = {
      'success': true,
      'results': 1,
      'data': [
        {
          'studentId': '6a65349c2796ce31be8b9d7c',
          'fullName': 'Gulf Test Student',
          'attendance': null,
        },
      ],
    };
    final students = await repo.getClassroomStudents(
      '6a65398115f5e200601af614',
    );
    final student = students.getOrElse(() => const []).single;
    expect(student.id, '6a65349c2796ce31be8b9d7c');

    api.response = {
      'success': true,
      'data': [
        {'id': 'subject', 'name': 'Math'},
      ],
    };
    final subjects = await repo.getStudentSubjects(
      classroomId: '6a65398115f5e200601af614',
      studentId: student.id,
    );
    expect(
      api.path,
      '/classrooms/6a65398115f5e200601af614/students/'
      '6a65349c2796ce31be8b9d7c/subjects',
    );
    expect(subjects.getOrElse(() => const []).single.id, 'subject');
  });

  test('empty studentId returns a failure without sending a request', () async {
    final result = await repo.getStudentSubjects(
      classroomId: 'classroom',
      studentId: '  ',
    );

    expect(result.isLeft(), isTrue);
    expect(api.getCalls, 0);
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
  Object response = {'success': true, 'data': <String, dynamic>{}};
  int getCalls = 0;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    getCalls++;
    this.path = path;
    query = queryParameter;
    return response;
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
