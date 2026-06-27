import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/update_name_cubit/update_name_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateNameCubit extends Cubit<UpdateNameState> {
  UpdateNameCubit(this.studentProfileRepo) : super(UpdateNameInitial());

  final StudentProfileRepo studentProfileRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  Future<void> updateName() async {
    if (!formKey.currentState!.validate()) return;

    emit(UpdateNameLoading());

    final result = await studentProfileRepo.updateLoggedUserName(
      fullName: nameController.text.trim(),
    );

    result.fold(
      (failure) {
        emit(UpdateNameFailure(errorMessage: failure.message));
      },
      (response) {
        emit(UpdateNameSuccess(message: response.message));
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}