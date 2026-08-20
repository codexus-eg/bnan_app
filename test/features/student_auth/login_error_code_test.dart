import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/login_cubit/login_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login keeps ACCOUNT_NOT_VERIFIED error code', (tester) async {
    final cubit = LoginCubit(_Repo());
    await tester.pumpWidget(
      MaterialApp(
        home: Form(key: cubit.formKey, child: const SizedBox()),
      ),
    );
    cubit.emailController.text = 'student@bnan.edu';
    cubit.passwordController.text = '12345678';
    await cubit.login();
    expect(cubit.state, isA<LoginFailure>());
    expect((cubit.state as LoginFailure).code, 'ACCOUNT_NOT_VERIFIED');
    await cubit.close();
  });
}

class _Repo implements AuthRepo {
  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String email,
    required String password,
  }) async =>
      Left(Failure(message: 'not verified', code: 'ACCOUNT_NOT_VERIFIED'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
