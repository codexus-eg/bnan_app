import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/update_password_cubit/update_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit(this.studentProfileRepo) : super(UpdatePasswordInitial());

  final StudentProfileRepo studentProfileRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool isCurrentPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordObscure = !isCurrentPasswordObscure;
    emit(UpdatePasswordVisibilityChanged());
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordObscure = !isNewPasswordObscure;
    emit(UpdatePasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    emit(UpdatePasswordVisibilityChanged());
  }

  Future<void> updatePassword() async {
    if (!formKey.currentState!.validate()) return;

    emit(UpdatePasswordLoading());

    final result = await studentProfileRepo.updatePassword(
      currentPassword: currentPasswordController.text.trim(),
      updatedPassword: newPasswordController.text.trim(),
    );

    result.fold(
      (failure) {
        emit(UpdatePasswordFailure(errorMessage: failure.message));
      },
      (response) {
        emit(UpdatePasswordSuccess(message: response.message));
      },
    );
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    return super.close();
  }
}