import 'dart:async';

import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(
    this.authRepo, {
    this.requestTimeout = const Duration(seconds: 15),
  }) : super(ForgotPasswordInitial());

  final AuthRepo authRepo;
  final Duration requestTimeout;

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  Timer? _resendTimer;
  int resendSeconds = 0;

  void prefillEmail(String email) => emailController.text = email.trim();

  void startResendCooldown([int seconds = 30]) {
    if (emailController.text.trim().isEmpty) return;
    _resendTimer?.cancel();
    resendSeconds = seconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      if (resendSeconds > 0) resendSeconds--;
      emit(ForgotPasswordCooldown(resendSeconds));
      if (resendSeconds == 0) timer.cancel();
    });
  }

  Future<void> forgotPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    await _sendResetCode();
    if (isClosed) return;
  }

  Future<void> resendCode({bool accountVerification = false}) async {
    if (resendSeconds > 0) return;
    if (emailController.text.trim().isEmpty) {
      emit(ForgotPasswordFailure(errorMessage: S.current.email));
      return;
    }

    if (accountVerification) {
      emit(ForgotPasswordLoading());
      try {
        final result = await authRepo
            .resendVerificationCode(email: emailController.text.trim())
            .timeout(requestTimeout);
        if (isClosed) return;
        result.fold(
          (failure) =>
              emit(ForgotPasswordFailure(errorMessage: failure.message)),
          (response) {
            emit(ForgotPasswordSuccess(message: response.message));
            startResendCooldown();
          },
        );
      } on TimeoutException {
        if (isClosed) return;
        emit(
          ForgotPasswordFailure(errorMessage: S.current.errorConnectionTimeout),
        );
      }
      return;
    }
    await _sendResetCode();
    if (isClosed) return;
  }

  Future<void> _sendResetCode() async {
    emit(ForgotPasswordLoading());

    try {
      final result = await authRepo
          .forgotPassword(email: emailController.text.trim())
          .timeout(requestTimeout);
      if (isClosed) return;
      result.fold(
        (failure) {
          emit(ForgotPasswordFailure(errorMessage: failure.message));
        },
        (response) {
          emit(ForgotPasswordSuccess(message: response.message));
          startResendCooldown();
        },
      );
    } on TimeoutException {
      if (isClosed) return;
      emit(
        ForgotPasswordFailure(errorMessage: S.current.errorConnectionTimeout),
      );
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    emailController.dispose();
    return super.close();
  }
}
