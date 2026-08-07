import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses id, underscore id, and missing fields safely', () {
    final subjects = StudentSubjectModel.listFromResponse({
      'success': true,
      'data': [
        {'id': 'one', 'name': 'English'},
        {'_id': 'two', 'name': 'Math'},
        {'id': null, 'name': null},
        null,
      ],
    });

    expect(subjects.map((item) => item.id), ['one', 'two', '', '']);
    expect(subjects.map((item) => item.name), ['English', 'Math', '', '']);
    expect(StudentSubjectModel.listFromResponse({'data': null}), isEmpty);
  });

  test('repository sends one protected GET without body or query', () async {
    final api = _FakeApi();

    final result = await StudentSubjectsRepoImpl(api).getMySubjects();

    expect(result.getOrElse(() => []), hasLength(1));
    expect(api.path, EndPoints.mySubjects);
    expect(api.data, isNull);
    expect(api.query, isNull);
    expect(api.isProtected, isTrue);
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  bool? isProtected;

  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    query = queryParameter;
    this.isProtected = isProtected;
    return {
      'data': [
        {'id': 'one', 'name': 'English'},
      ],
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
