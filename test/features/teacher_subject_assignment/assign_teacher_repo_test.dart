import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const backendMessage =
      'يوجد معلم معيّن بالفعل لهذا الفصل الخليجي. يجب إلغاء تعيين المعلم '
      'الحالي أولاً قبل تعيين معلم جديد.';
  const request = AssignTeacherRequestModel(
    curriculumId: 'curriculum-1',
    gradeId: 'grade-1',
    classroomId: 'classroom-1',
    subjectId: 'subject-1',
    pricePerSession: 300,
  );

  test('assign uses one protected PUT with the exact contract', () async {
    final api = _FakeApi();
    final result = await TeacherSubjectAssignmentRepoImpl(
      api,
    ).assignTeacher(teacherId: 'teacher-1', request: request);

    expect(result.isRight(), isTrue);
    expect(api.putCalls, 1);
    expect(api.path, EndPoints.assignTeacher('teacher-1'));
    expect(api.data, request.toJson());
    expect(api.query, isNull);
    expect(api.isProtected, isTrue);
    expect((api.data as Map).keys, request.toJson().keys);
  });

  test('assign converts API exceptions through repoGuard', () async {
    final api = _FakeApi()..error = const AppException(backendMessage);
    final result = await TeacherSubjectAssignmentRepoImpl(
      api,
    ).assignTeacher(teacherId: 'teacher-1', request: request);
    expect(
      result.fold((failure) => failure.message, (_) => ''),
      backendMessage,
    );
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  bool isProtected = false;
  int putCalls = 0;
  AppException? error;

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    putCalls++;
    this.path = path;
    this.data = data;
    query = queryParameter;
    this.isProtected = isProtected;
    if (error != null) throw error!;
    return {'success': true, 'message': 'assigned'};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
