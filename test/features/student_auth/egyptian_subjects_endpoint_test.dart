import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Egyptian subjects use the grade subjects endpoint', () async {
    final api = _Api();
    final result = await AuthRepoImpl(
      apiConsumer: api,
    ).getCurriculumSubjects(curriculumId: 'curriculum', gradeId: 'grade');
    expect(api.requestedPath, EndPoints.gradeSubjects('grade'));
    result.fold((_) => fail('Expected subjects'), (value) {
      expect(value.subjects.single.id, 'subject');
    });
  });
}

class _Api implements ApiConsumer {
  String? requestedPath;
  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    requestedPath = path;
    return {
      'success': true,
      'data': [
        {'id': 'subject', 'name': 'Math'},
      ],
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
