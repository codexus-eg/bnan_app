import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  StudentProfileCubit(this.studentProfileRepo) : super(StudentProfileStateInitial());

  final StudentProfileRepo studentProfileRepo;

  static StudentProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getLoggedUser() async {
    emit(StudentProfileStateLoading());

    final result = await studentProfileRepo.getLoggedUser();

    result.fold(
      (failure) {
        emit(StudentProfileStateFailure(errorMessage: failure.message));
      },
      (response) {
        emit(StudentProfileStateSuccess(loggedUser: response.loggedUser));
      },
    );
  }

  Future<void> logout() async {
    await studentProfileRepo.logout();
  }
}