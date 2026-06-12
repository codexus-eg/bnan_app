import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.authRepo) : super(ForgotPasswordInitial());

  final AuthRepo authRepo;

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> forgotPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    await _sendResetCode();
  }

  Future<void> resendCode() async {
    if (emailController.text.trim().isEmpty) {
      emit(ForgotPasswordFailure(errorMessage: S.current.email));
      return;
    }

    await _sendResetCode();
  }

  Future<void> _sendResetCode() async {
    emit(ForgotPasswordLoading());

    final result = await authRepo.forgotPassword(
      email: emailController.text.trim(),
    );

    result.fold(
      (failure) {
        emit(ForgotPasswordFailure(errorMessage: failure.message));
      },
      (response) {
        emit(ForgotPasswordSuccess(message: response.message));
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}