import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getTeacherTeachingAssignments sends teacher and subject query params', () async {
    final api = _FakeApi();
    final repo = TeacherSubjectAssignmentRepoImpl(api);

    await repo.getTeacherTeachingAssignments(
      keyword: 'Ahmed',
      subject: 'Math',
    );

    expect(api.path, EndPoints.teachingAssignments);
    expect(api.isProtected, isTrue);
    expect(api.query, {
      'teacher': 'Ahmed',
      'subject': 'Math',
    });
  });

  test('getTeacherTeachingAssignments ignores empty query params', () async {
    final api = _FakeApi();
    final repo = TeacherSubjectAssignmentRepoImpl(api);

    await repo.getTeacherTeachingAssignments(
      keyword: '   ',
      subject: null,
    );

    expect(api.path, EndPoints.teachingAssignments);
    expect(api.query, isEmpty);
  });

  group('TeachingAssignmentsResponseModel parsing', () {
    test('extracts teacher name from nested user.fullName', () {
      final json = {
        'success': true,
        'length': 1,
        'data': [
          {
            '_id': 'teacher-123',
            'user': {
              'fullName': 'Dr. Mostafa Ahmed',
              'email': 'mostafa@bnan.com',
            },
            'curriculums': [],
          }
        ],
      };

      final model = TeachingAssignmentsResponseModel.fromJson(json);
      expect(model.data.length, 1);
      expect(model.data.first.teacher.id, 'teacher-123');
      expect(model.data.first.teacher.name, 'Dr. Mostafa Ahmed');
      expect(model.data.first.teacher.displayName, 'Dr. Mostafa Ahmed');
      expect(model.data.first.teacher.email, 'mostafa@bnan.com');
    });

    test('extracts teacher name from legacy nested teacher.name', () {
      final json = {
        'success': true,
        'length': 1,
        'data': [
          {
            'teacher': {
              '_id': 'teacher-456',
              'name': 'Prof. Mona Ali',
            },
            'curriculums': [],
          }
        ],
      };

      final model = TeachingAssignmentsResponseModel.fromJson(json);
      expect(model.data.first.teacher.id, 'teacher-456');
      expect(model.data.first.teacher.displayName, 'Prof. Mona Ali');
    });

    test('falls back to بدون اسم when name is missing or empty', () {
      final json = {
        'success': true,
        'length': 1,
        'data': [
          {
            '_id': 'teacher-789',
            'user': {},
          }
        ],
      };

      final model = TeachingAssignmentsResponseModel.fromJson(json);
      expect(model.data.first.teacher.id, 'teacher-789');
      expect(model.data.first.teacher.displayName, 'بدون اسم');
    });
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Map<String, dynamic>? query;
  bool isProtected = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    query = queryParameter;
    this.isProtected = isProtected;
    return {
      'success': true,
      'length': 0,
      'data': [],
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
