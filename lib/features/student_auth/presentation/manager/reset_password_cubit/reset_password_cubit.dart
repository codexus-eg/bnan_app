import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/reset_password_cubit/reset_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());

  final AuthRepo authRepo;

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    emit(ResetPasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(ResetPasswordVisibilityChanged());
  }

  Future<void> verifyResetCode() async {
    final resetCode = otpController.text.trim();

    if (resetCode.isEmpty) {
      emit(ResetPasswordFailure(errorMessage: S.current.resetCodeRequired));
      return;
    }

    emit(ResetPasswordLoading());

    final result = await authRepo.verifyResetCode(resetCode: resetCode);

    if (isClosed) return;

    result.fold(
      (failure) => emit(ResetPasswordFailure(errorMessage: failure.message)),
      (response) => emit(VerifyResetCodeSuccess(message: response.message)),
    );
  }

  Future<void> verifyAccount({required String email}) async {
    final code = otpController.text.trim();
    if (code.isEmpty) {
      emit(ResetPasswordFailure(errorMessage: S.current.resetCodeRequired));
      return;
    }
    emit(ResetPasswordLoading());
    final result = await authRepo.verifyAccount(email: email, code: code);
    if (isClosed) return;
    result.fold(
      (failure) => emit(ResetPasswordFailure(errorMessage: failure.message)),
      (response) => emit(VerifyAccountSuccess(message: response.message)),
    );
  }

  Future<void> resetPassword({required String email}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      emit(ResetPasswordFailure(errorMessage: S.current.passwordsDoNotMatch));
      return;
    }

    emit(ResetPasswordLoading());

    final result = await authRepo.resetPassword(
      email: email.trim(),
      newPassword: newPasswordController.text,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ResetPasswordFailure(errorMessage: failure.message)),
      (response) => emit(ResetPasswordSuccess(message: response.message)),
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
