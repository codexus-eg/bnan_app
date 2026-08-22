import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  test('sends forgot-password code once', () async {
    final repo = _Repo()..completeSuccess();
    final cubit = ForgotPasswordCubit(repo)..prefillEmail('a@b.com');
    await cubit.resendCode();
    expect(repo.calls, 1);
    expect(cubit.state, isA<ForgotPasswordSuccess>());
    await cubit.close();
  });

  test('timeout ends loading with failure', () async {
    final repo = _Repo();
    final cubit = ForgotPasswordCubit(
      repo,
      requestTimeout: const Duration(milliseconds: 1),
    )..prefillEmail('a@b.com');
    await cubit.resendCode();
    expect(cubit.state, isA<ForgotPasswordFailure>());
    await cubit.close();
  });

  test('closing during loading does not emit after close', () async {
    final repo = _Repo();
    final cubit = ForgotPasswordCubit(repo)..prefillEmail('a@b.com');
    final request = cubit.resendCode();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<ForgotPasswordLoading>());
    await cubit.close();
    repo.completeSuccess();
    await request;
  });
}

class _Repo implements AuthRepo {
  final completer = Completer<Either<Failure, SimpleResponseModel>>();
  int calls = 0;

  void completeSuccess() => completer.complete(
    Right(SimpleResponseModel(success: true, message: 'sent')),
  );

  @override
  Future<Either<Failure, SimpleResponseModel>> forgotPassword({
    required String email,
  }) {
    calls++;
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
