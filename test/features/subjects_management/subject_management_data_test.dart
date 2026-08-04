import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo_imple.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const request = AddSubjectRequestModel(
    name: 'Arabic22',
    curriculumId: 'curriculum-1',
    gradeId: 'grade-1',
  );

  test('add request sends the exact backend contract', () {
    expect(request.toJson(), {
      'name': 'Arabic22',
      'curriculum': 'curriculum-1',
      'grade': 'grade-1',
    });
    expect(request.toJson(), isNot(contains('gradeId')));
  });

  test('subject response safely parses optional grade', () {
    final subject = SubjectModel.fromJson({
      'id': 'subject-1',
      'name': 'Arabic22',
      'grade': {'id': 'grade-1', 'name': 'Grade one'},
    });
    expect(subject.grade?.id, 'grade-1');
    expect(subject.grade?.name, 'Grade one');
    expect(SubjectModel.fromJson({'id': 'subject-2'}).grade, isNull);
  });

  test('subject response reads pagination from the API', () {
    final response = SubjectsResponseModel.fromJson({
      'success': true,
      'data': <Object>[],
      'pagination': {
        'currentPage': '2',
        'perPage': 15,
        'total': '31',
        'lastPage': 3,
      },
    });

    expect(response.pagination.currentPage, 2);
    expect(response.pagination.perPage, 15);
    expect(response.pagination.total, 31);
    expect(response.pagination.lastPage, 3);
  });

  test('repository posts protected request through repoGuard', () async {
    final api = _Api();
    final result = await SubjectsRepoImpl(api).addSubject(request: request);
    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.subjects);
    expect(api.data, request.toJson());
    expect(api.isProtected, isTrue);

    api.error = const AppException('backend error');
    final failure = await SubjectsRepoImpl(api).addSubject(request: request);
    expect(failure.fold((item) => item.message, (_) => ''), 'backend error');
  });

  test('repository sends page and perPage with protected get', () async {
    final api = _Api();
    final result = await SubjectsRepoImpl(
      api,
    ).getSubjects(page: 2, perPage: 15);

    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.subjects);
    expect(api.query, {'page': 2, 'perPage': 15});
    expect(api.isProtected, isTrue);
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? data;
  bool isProtected = false;
  Map<String, dynamic>? query;
  AppException? error;

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
      'data': <Object>[],
      'pagination': {
        'currentPage': 2,
        'perPage': 15,
        'total': 0,
        'lastPage': 1,
      },
    };
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    this.isProtected = isProtected;
    if (error != null) throw error!;
    return {'success': true};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
