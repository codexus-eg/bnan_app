import 'package:bnan_app/features/shared_profile/data/repo/teacher_profile_repo/teacher_profile_repo.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/session/session_manager.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  TeacherProfileCubit(this.teacherProfileRepo) : super(TeacherProfileInitial());

  final TeacherProfileRepo teacherProfileRepo;

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getTeacherProfile() async {
    if (isClosed) return;
    emit(TeacherProfileLoading());

    final result = await teacherProfileRepo.getTeacherProfile();

    if (isClosed) return;
    await result.fold(
      (failure) {
        if (isClosed) return;
        emit(TeacherProfileFailure(errorMessage: failure.message));
      },
      (response) async {
        final profile = response.teacherProfile;
        await SessionManager.instance.mergeCurrentUser(
          id: profile.user.id,
          fullName: profile.user.fullName,
          email: profile.user.email,
          phone: profile.phone,
          role: 'teacher',
        );
        if (isClosed) return;
        emit(TeacherProfileSuccess(teacherProfile: profile));
      },
    );
  }
}
