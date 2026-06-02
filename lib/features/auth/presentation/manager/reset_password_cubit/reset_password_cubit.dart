import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/reset_password_cubit/reset_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());

  final AuthRepo authRepo;

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> verifyResetCode() async {
    final resetCode = otpController.text.trim();

    if (resetCode.isEmpty) {
      emit(ResetPasswordFailure(errorMessage: S.current.resetCodeRequired));
      return;
    }

    emit(ResetPasswordLoading());

    final result = await authRepo.verifyResetCode(resetCode: resetCode);

    result.fold(
      (failure) {
        emit(ResetPasswordFailure(errorMessage: failure.message));
      },
      (response) {
        emit(VerifyResetCodeSuccess(message: response.message));
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(
        ResetPasswordFailure(
          errorMessage: S.current.passwordAndConfirmRequired,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      emit(ResetPasswordFailure(errorMessage: S.current.passwordsDoNotMatch));
      return;
    }

    emit(ResetPasswordLoading());

    final result = await authRepo.resetPassword(
      email: email.trim(),
      newPassword: newPassword,
    );

    result.fold(
      (failure) {
        emit(ResetPasswordFailure(errorMessage: failure.message));
      },
      (response) {
        emit(ResetPasswordSuccess(message: response.message));
      },
    );
  }

  @override
  Future<void> close() {
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
