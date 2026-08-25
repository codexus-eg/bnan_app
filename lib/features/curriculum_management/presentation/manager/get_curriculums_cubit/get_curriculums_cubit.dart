import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCurriculumsCubit extends Cubit<GetCurriculumsState> {
  GetCurriculumsCubit(this.curriculumManagementRepo)
    : super(GetCurriculumsInitial());

  final CurriculumManagementRepo curriculumManagementRepo;
  int _requestVersion = 0;

  Future<void> getCurriculums() async {
    if (isClosed) return;
    final version = ++_requestVersion;
    emit(GetCurriculumsLoading());

    final result = await curriculumManagementRepo.getCurriculums();
    if (isClosed || version != _requestVersion) return;

    result.fold(
      (failure) => emit(GetCurriculumsFailure(failure.message)),
      (response) => emit(GetCurriculumsSuccess(response.data)),
    );
  }

  void removeCurriculum(String curriculumId) {
    final current = state;
    if (isClosed || current is! GetCurriculumsSuccess) return;
    emit(
      GetCurriculumsSuccess(
        current.curriculums
            .where((curriculum) => curriculum.id != curriculumId)
            .toList(growable: false),
      ),
    );
  }
}
