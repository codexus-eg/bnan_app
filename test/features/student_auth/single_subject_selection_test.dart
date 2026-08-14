import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  test('single-subject packages keep only one selected subject', () {
    final cubit = RegisterCubit(_FakeAuthRepo(), _FakeGulfParentAuthRepo());
    cubit.setRegisterFlowArgs(
      const RegisterFlowArgsModel(
        curriculumId: 'curriculum',
        curriculumName: 'Egyptian',
        packageId: 'package',
        packageName: 'Single subject',
        packagePrice: '250',
        packageCurrency: 'EGP',
        registrationMode: 'egyptian',
        accessScope: 'single_subject',
      ),
    );

    cubit.toggleSubject('math');
    cubit.toggleSubject('science');

    expect(cubit.selectedSubjectIds, ['science']);
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

const _request = RegisterRequestModel(
  parent: RegisterParentModel(
    fullName: 'Parent',
    email: 'p@e.com',
    phone: '+201000000000',
    password: 'Password1',
    whatsappNumber: '+201000000000',
  ),
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

  @override
  register({required RegisterRequestModel request}) async {
    registerCalls++;
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
