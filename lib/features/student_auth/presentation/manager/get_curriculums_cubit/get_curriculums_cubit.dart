import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCurriculumsCubit extends Cubit<GetCurriculumsState> {
  GetCurriculumsCubit(this.authRepo) : super(GetCurriculumsInitial());

  final AuthRepo authRepo;

  static GetCurriculumsCubit get(BuildContext context) {
    return BlocProvider.of<GetCurriculumsCubit>(context);
  }

  Future<void> getAllCurriculums() async {
    if (isClosed) return;
    emit(GetCurriculumsLoading());

    final result = await authRepo.getAllCurriculums();
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetCurriculumsFailure(errorMessage: failure.message));
      },
      (response) {
        emit(GetCurriculumsSuccess(curriculums: response.curriculums));
      },
    );
  }
}
