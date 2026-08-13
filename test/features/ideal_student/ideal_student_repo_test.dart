import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/ideal_student/data/repos/ideal_student_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fetches protected ranking for classroom and pagination', () async {
    final api = _Api();
    await IdealStudentRepoImpl(
      api,
    ).getWeeklyRanking(classroomId: 'abc123', page: 1, limit: 20);
    expect(api.path, EndPoints.classroomWeeklyRanking('abc123'));
    expect(api.path, '/classrooms/abc123/weekly-ranking');
    expect(api.path, isNot('/egyptian-weekly-rankings/abc123'));
    expect(api.query, {'page': 1, 'limit': 20});
    expect(api.protected, isTrue);
  });
}

class _Api implements ApiConsumer {
  String? path;
  Map<String, dynamic>? query;
  bool protected = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    query = queryParameter;
    protected = isProtected;
    return {
      'data': {'status': 'insufficient_data', 'ranking': []},
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
