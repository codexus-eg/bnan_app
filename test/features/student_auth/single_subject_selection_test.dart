import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

void main() {
  for (final subjects in const <List<String>>[
    [],
    ['math'],
    ['math', 'arabic'],
    ['math', 'arabic', 'english'],
  ]) {
    test('Egyptian private accepts ${subjects.length} selected subjects', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo());
      cubit.setRegisterFlowArgs(_egyptianPrivateArgs);
      cubit.setGrade(id: 'grade', name: 'Grade');
      for (final subject in subjects) {
        cubit.toggleSubject(subject);
      }

      final request = cubit.buildRegisterRequest();
      if (subjects.isEmpty) {
        expect(request, isNull);
      } else {
        expect(request?.student.subjects, subjects);
        expect(request?.items, hasLength(subjects.length));
        expect(request?.items.map((item) => item.subjectId), subjects);
        expect(request?.items.map((item) => item.packageId).toSet(), {
          'package',
        });
        expect(request?.toJson().containsKey('packageId'), isFalse);
      }
    });
  }

  for (final subjects in const <List<String>>[
    [],
    ['math'],
    ['math', 'arabic'],
    ['math', 'arabic', 'english'],
  ]) {
    test('Gulf private checkout accepts ${subjects.length} subjects', () {
      final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
        ..setRegisterFlowArgs(_gulfPrivateArgs)
        ..setGrade(id: 'grade', name: 'Grade');
      for (final subject in subjects) {
        cubit.toggleSubject(subject);
      }

      final request = cubit.buildTamaraRequest(validateForm: false);
      if (subjects.isEmpty) {
        expect(request, isNull);
      } else {
        expect(request?.student.subjects, subjects);
        expect(request?.packageId, 'gulf-package');
        final json = request!.toJson();
        final items = (json['items'] as List).cast<Map<String, dynamic>>();
        expect(json.containsKey('packageId'), isFalse);
        expect(json.containsKey('purchaseItems'), isFalse);
        expect(items, [
          for (final subjectId in subjects)
            {'subjectId': subjectId, 'packageId': 'gulf-package'},
        ]);
        expect(
          items.map((item) => item['subjectId']),
          (json['student'] as Map<String, dynamic>)['subjects'],
        );
      }
    });
  }

  test(
    'parsed Egyptian private package reaches repository with two subjects',
    () async {
      final package = PackageModel.fromJson({
        'id': 'private-package',
        'packageType': 'hours',
        'accessScope': 'single_subject',
      });
      final repo = _FakeAuthRepo();
      final cubit = RegisterCubit(repo, _FakeGulfParentAuthRepo());
      cubit.setRegisterFlowArgs(
        RegisterFlowArgsModel(
          curriculumId: 'curriculum',
          curriculumName: 'Egyptian',
          packageId: package.id!,
          packageName: 'Private',
          packagePrice: '250',
          packageCurrency: 'EGP',
          registrationMode: 'egyptian',
          accessScope: package.accessScope,
          packageType: package.type ?? '',
        ),
      );
      cubit.setGrade(id: 'grade', name: 'Grade');
      cubit.toggleSubject('math');
      cubit.toggleSubject('arabic');

      final request = cubit.buildRegisterRequest();
      expect(cubit.isEgyptianPrivate, isTrue);
      expect(request?.student.subjects, ['math', 'arabic']);
      expect(request?.toJson()['items'], [
        {'subjectId': 'math', 'packageId': 'private-package'},
        {'subjectId': 'arabic', 'packageId': 'private-package'},
      ]);
      await cubit.register(request: request!);
      expect(repo.lastRequest?.student.subjects, ['math', 'arabic']);
      expect(repo.lastRequest?.items.map((item) => item.subjectId), [
        'math',
        'arabic',
      ]);
    },
  );

  test('Egyptian private items contain no duplicate or extra subjects', () {
    final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo())
      ..setRegisterFlowArgs(_egyptianPrivateArgs)
      ..setGrade(id: 'grade', name: 'Grade')
      ..selectedSubjectIds = ['math', 'math', 'arabic'];

    final request = cubit.buildRegisterRequest()!;
    expect(request.student.subjects, ['math', 'arabic']);
    expect(request.items.map((item) => item.subjectId), ['math', 'arabic']);
  });

  testWidgets('Egyptian private passes the real student form guard', (
    tester,
  ) async {
    final repo = _FakeAuthRepo();
    final cubit = RegisterCubit(repo, _FakeGulfParentAuthRepo())
      ..setRegisterFlowArgs(_egyptianPrivateArgs)
      ..studentNameController.text = 'Student Name'
      ..studentEmailController.text = 'student@example.com'
      ..studentPasswordController.text = 'Password1'
      ..setGrade(id: 'grade', name: 'Grade')
      ..toggleSubject('math')
      ..toggleSubject('arabic');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: cubit.studentFormKey,
            child: Column(
              children: [
                TextFormField(controller: cubit.studentNameController),
                TextFormField(controller: cubit.studentEmailController),
                TextFormField(controller: cubit.studentPasswordController),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(cubit.validateStudent(), isTrue);
    final request = cubit.buildRegisterRequest();
    final submission = cubit.register(request: request!);
    await tester.pump(const Duration(milliseconds: 20));
    await submission;
    expect(repo.lastRequest?.student.subjects, ['math', 'arabic']);
  });

  test('Egyptian all-subjects payload uses every loaded grade subject', () {
    final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo());
    cubit.setRegisterFlowArgs(_args('egyptian'));
    cubit.setGrade(id: 'grade', name: 'Grade');
    cubit.setAllSubjectIds(const ['math', 'science']);

    expect(cubit.requiresSubjectSelection, isFalse);
    final request = cubit.buildRegisterRequest()!;
    expect(request.student.subjects, ['math', 'science']);
    expect(request.toJson()['packageId'], 'package');
    expect(request.toJson().containsKey('items'), isFalse);
  });

  test('Egyptian and Gulf flows both end at their fourth step', () {
    final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo());
    cubit.setRegisterFlowArgs(_args('egyptian'));
    expect(cubit.lastStep, 4);
    cubit.setRegisterFlowArgs(_args('gulf'));
    expect(cubit.lastStep, 4);
    for (var index = 0; index < 5; index++) {
      cubit.nextStep();
    }
    expect(cubit.state.currentStep, 4);
  });

  test('duplicate registration submission is ignored', () async {
    final repo = _FakeAuthRepo();
    final cubit = RegisterCubit(repo, _FakeGulfParentAuthRepo());
    await Future.wait([
      cubit.register(request: _request),
      cubit.register(request: _request),
    ]);
    expect(repo.registerCalls, 1);
  });

  test('student registration sends only parent email and password', () {
    expect(_request.toJson()['parent'], {
      'email': 'p@e.com',
      'password': 'Password1',
    });
  });
}

RegisterFlowArgsModel _args(String mode) => RegisterFlowArgsModel(
  curriculumId: 'curriculum',
  curriculumName: 'Curriculum',
  packageId: 'package',
  packageName: 'Package',
  packagePrice: '250',
  packageCurrency: mode == 'gulf' ? 'SAR' : 'EGP',
  registrationMode: mode,
);

const _egyptianPrivateArgs = RegisterFlowArgsModel(
  curriculumId: 'curriculum',
  curriculumName: 'Egyptian',
  packageId: 'package',
  packageName: 'Private',
  packagePrice: '250',
  packageCurrency: 'EGP',
  registrationMode: 'egyptian',
  accessScope: 'single_subject',
  packageType: 'hours',
);

const _gulfPrivateArgs = RegisterFlowArgsModel(
  curriculumId: 'gulf-curriculum',
  curriculumName: 'Gulf',
  packageId: 'gulf-package',
  packageName: '8 Hours',
  packagePrice: '250',
  packageCurrency: 'SAR',
  registrationMode: 'gulf',
  accessScope: 'single_subject',
  packageType: 'hours',
);

const _request = RegisterRequestModel(
  parent: RegisterParentModel(email: 'p@e.com', password: 'Password1'),
  student: RegisterStudentModel(
    fullName: 'Student',
    email: 's@e.com',
    password: 'Password1',
    grade: 'g1',
    subjects: ['math'],
  ),
  curriculum: 'c1',
  packageId: 'p1',
);

class _FakeAuthRepo implements AuthRepo {
  int registerCalls = 0;
  RegisterRequestModel? lastRequest;

  @override
  register({required RegisterRequestModel request}) async {
    registerCalls++;
    lastRequest = request;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const Right(
      AuthResponseModel(
        success: true,
        token: '',
        user: AuthUserModel(
          id: '1',
          fullName: 'Student',
          email: 's@e.com',
          role: 'student',
          status: 'pending',
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
