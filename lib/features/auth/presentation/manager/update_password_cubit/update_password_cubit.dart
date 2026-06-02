import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/update_password_cubit/update_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit(this.authRepo) : super(UpdatePasswordInitial());

  final AuthRepo authRepo;

  Future<void> updatePassword({
    required String currentPassword,
    required String updatedPassword,
  }) async {
    emit(UpdatePasswordLoading());

    final result = await authRepo.updatePassword(
      currentPassword: currentPassword,
      updatedPassword: updatedPassword,
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
}