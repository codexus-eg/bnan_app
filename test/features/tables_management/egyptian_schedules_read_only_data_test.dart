import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses my schedule response with its academic references', () {
    final response = EgyptianSchedulesResponseModel.fromJson(_response());
    final schedule = response.schedules.single;

    expect(response.results, 1);
    expect(schedule.classroom?.name, 'Grade 1 - A');
    expect(schedule.grade?.name, 'Grade 1');
    expect(schedule.curriculum?.name, 'Egyptian');
    expect(schedule.image, 'https://api.example.com/schedule.jpg');
  });

  test('defaults missing schedules to an empty list', () {
    final response = EgyptianSchedulesResponseModel.fromJson({
      'success': true,
      'results': 0,
      'data': {'schedules': <Object>[]},
    });

    expect(response.schedules, isEmpty);
  });

  test('repository uses the protected mySchedule endpoint', () async {
    final api = _Api(_response());
    final result = await TableManagementRepoImpl(api).getMyEgyptianSchedule();

    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.myEgyptianSchedule);
    expect(api.isProtected, isTrue);
  });

  test('parent schedule sends the selected child id', () async {
    final api = _Api(_response());
    await TableManagementRepoImpl(
      api,
    ).getMyEgyptianSchedule(studentId: ' child-1 ');

    expect(api.query, {'studentId': 'child-1'});
  });
}

Map<String, dynamic> _response() => {
  'success': true,
  'results': 1,
  'data': {
    'schedules': [
      {
        'id': 'scheduleId',
        'classroom': {'id': 'classroomId', 'name': 'Grade 1 - A'},
        'grade': {'id': 'gradeId', 'name': 'Grade 1'},
        'curriculum': {'id': 'curriculumId', 'name': 'Egyptian'},
        'image': 'https://api.example.com/schedule.jpg',
      },
    ],
  },
};

class _Api implements ApiConsumer {
  _Api(this.response);

  final Map<String, dynamic> response;
  String? path;
  bool? isProtected;
  Map<String, dynamic>? query;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.isProtected = isProtected;
    query = queryParameter;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
