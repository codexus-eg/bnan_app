import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('response parses classrooms and nested lookups safely', () {
    final response = GetSupervisorClassroomsResponseModel.fromJson({
      'success': true,
      'results': '1',
      'data': [
        {
          '_id': 'classroom-id',
          'name': 'Classroom',
          'grade': {'id': 'grade-id', 'name': 'Grade'},
          'curriculum': {'_id': 'curriculum-id', 'name': 'Egyptian'},
        },
      ],
    });

    expect(response.results, 1);
    expect(response.data.single.id, 'classroom-id');
    expect(response.data.single.grade.id, 'grade-id');
    expect(response.data.single.curriculum.id, 'curriculum-id');
    expect(GetSupervisorClassroomsResponseModel.fromJson({}).data, isEmpty);
  });

  test(
    'repository uses the protected supervisor classrooms endpoint',
    () async {
      final api = FakeApiConsumer();
      final result = await SupervisorManagementRepoImpl(api).getMyClassrooms();

      expect(api.path, EndPoints.supervisorMyClassrooms);
      expect(api.isProtected, isTrue);
      expect(result.isRight(), isTrue);
    },
  );
}

class FakeApiConsumer implements ApiConsumer {
  String path = '';
  bool isProtected = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.isProtected = isProtected;
    return {'success': true, 'results': 0, 'data': <Object>[]};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
