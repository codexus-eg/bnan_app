import 'dart:io';

import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeApiConsumer api;
  late PlansRepoImpl repo;

  setUp(() {
    api = FakeApiConsumer();
    repo = PlansRepoImpl(api);
  });

  test('daily creation sends JSON to the shared create endpoint', () async {
    await repo.createDailyPlan(
      classroomId: 'classroom',
      subjectId: 'subject',
      request: const CreateDailyPlanRequestModel(
        day: '2026-07-29',
        sessionContent: 'lesson',
        sessionAssignment: 'homework',
      ),
    );

    expect(api.path, '/classrooms/classroom/plans/subject');
    expect((api.data as Map<String, dynamic>)['type'], 'day');
    expect(api.isFormData, isFalse);
    expect(api.isProtected, isTrue);
  });

  test('read methods use the documented endpoints', () async {
    await repo.getPlansByWeek(classroomId: 'classroom');
    expect(api.path, '/classrooms/classroom/plans');
    await repo.getPlansByWeek(classroomId: 'classroom', week: 3);
    expect(api.path, '/classrooms/classroom/plans/week/3');
    await repo.getTermPlans(classroomId: 'classroom');
    expect(api.path, '/classrooms/classroom/plans/term');
    await repo.getElapsedWeeks(classroomId: 'classroom');
    expect(api.path, '/classrooms/classroom/plans/weeks/elapsed');
  });

  test('term upload sends term and attachment as form data', () async {
    final file = File('${Directory.systemTemp.path}/plans-upload-test.txt');
    await file.writeAsString('plan');
    addTearDown(() => file.deleteSync());

    await repo.uploadTermPlan(
      classroomId: 'classroom',
      subjectId: 'subject',
      attachmentPath: file.path,
    );

    final formData = api.data as FormData;
    expect(
      formData.fields.any(
        (entry) => entry.key == 'type' && entry.value == 'term',
      ),
      isTrue,
    );
    expect(formData.files.single.key, 'attachment');
    expect(api.isFormData, isTrue);
    expect(
      api.path,
      EndPoints.createPlan(classroomId: 'classroom', subjectId: 'subject'),
    );
  });
}

class FakeApiConsumer implements ApiConsumer {
  String path = '';
  Object? data;
  bool isFormData = false;
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
    return {'success': true, 'data': <String, dynamic>{}};
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
    this.isFormData = isFormData;
    this.isProtected = isProtected;
    return {'success': true, 'data': <String, dynamic>{}};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
