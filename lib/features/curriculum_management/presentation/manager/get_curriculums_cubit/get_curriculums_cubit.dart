import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCurriculumsCubit extends Cubit<GetCurriculumsState> {
  GetCurriculumsCubit(this.curriculumManagementRepo)
    : super(GetCurriculumsInitial());

  final CurriculumManagementRepo curriculumManagementRepo;

  Future<void> getCurriculums() async {
    emit(GetCurriculumsLoading());

    final result = await curriculumManagementRepo.getCurriculums();

    result.fold(
      (failure) => emit(GetCurriculumsFailure(failure.message)),
      (response) => emit(GetCurriculumsSuccess(response.data)),
    );
  }
}
