import 'package:bnan_app/features/shared_profile/data/repo/teacher_profile_repo/teacher_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  TeacherProfileCubit(this.teacherProfileRepo)
      : super(TeacherProfileInitial());

  final TeacherProfileRepo teacherProfileRepo;

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getTeacherProfile() async {
    emit(TeacherProfileLoading());

    final result = await teacherProfileRepo.getTeacherProfile();

    result.fold(
      (failure) {
        emit(TeacherProfileFailure(errorMessage: failure.message));
      },
      (response) {
        emit(
          TeacherProfileSuccess(
            teacherProfile: response.teacherProfile,
          ),
        );
      },
    );
  }
}