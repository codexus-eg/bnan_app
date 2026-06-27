import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/update_phone_cubit/update_phone_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePhoneCubit extends Cubit<UpdatePhoneState> {
  UpdatePhoneCubit(this.studentProfileRepo) : super(UpdatePhoneInitial());

  final StudentProfileRepo studentProfileRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  Future<void> updatePhone() async {
    if (!formKey.currentState!.validate()) return;

    emit(UpdatePhoneLoading());

    final result = await studentProfileRepo.updateLoggedUserPhone(
      phone: phoneController.text.trim(),
    );

    result.fold(
      (failure) {
        emit(UpdatePhoneFailure(errorMessage: failure.message));
      },
      (response) {
        emit(UpdatePhoneSuccess(message: response.message));
      },
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    return super.close();
  }
}