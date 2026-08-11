import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

class _FakeAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
