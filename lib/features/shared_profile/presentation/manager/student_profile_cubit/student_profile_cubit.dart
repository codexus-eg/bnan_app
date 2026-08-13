import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/session/session_manager.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  StudentProfileCubit(this.studentProfileRepo)
    : super(StudentProfileStateInitial());

  final StudentProfileRepo studentProfileRepo;

  static StudentProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getLoggedUser() async {
    if (isClosed) return;
    emit(StudentProfileStateLoading());

    final result = await studentProfileRepo.getLoggedUser();

    if (isClosed) return;
    await result.fold(
      (failure) {
        if (isClosed) return;
        emit(StudentProfileStateFailure(errorMessage: failure.message));
      },
      (response) async {
        final user = response.loggedUser.user;
        await SessionManager.instance.mergeCurrentUser(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          role: user.role,
        );
        if (isClosed) return;
        emit(StudentProfileStateSuccess(loggedUser: response.loggedUser));
      },
    );
  }

  Future<void> logout() async {
    await studentProfileRepo.logout();
  }
}
