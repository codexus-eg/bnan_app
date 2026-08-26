import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  final cases = <(Failure, Type)>[
    (Failure(message: 'missing', statusCode: 404), ParentRegistrationRequired),
    (
      Failure(message: 'inactive', code: 'ACCOUNT_NOT_VERIFIED'),
      ParentVerificationRequired,
    ),
  ];
  for (final scenario in cases) {
    testWidgets('maps ${scenario.$1.message} parent correctly', (tester) async {
      final cubit = RegisterCubit(_AuthRepo(), _ParentRepo(scenario.$1));
      addTearDown(cubit.close);
      await tester.pumpWidget(
        MaterialApp(
          home: Form(key: cubit.parentFormKey, child: const SizedBox()),
        ),
      );
      cubit.applyParentCredentials(
        email: 'parent@bnan.edu',
        password: '12345678',
      );
      await cubit.authenticateParentAndContinue();
      expect(cubit.state.runtimeType, scenario.$2);
    });
  }
}

class _AuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ParentRepo implements GulfParentAuthRepo {
  _ParentRepo(this.failure);
  final Failure failure;
  @override
  Future<Either<Failure, AuthResponseModel>> authenticate(
    RegisterParentModel request,
  ) async => Left(failure);
}
