import 'package:bnan_app/features/curriculum_management/data/models/create_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumActionsCubit extends Cubit<CurriculumActionsState> {
  CurriculumActionsCubit(this.curriculumManagementRepo)
    : super(CurriculumActionsInitial());

  final CurriculumManagementRepo curriculumManagementRepo;

  Future<void> createCurriculum(CreateCurriculumRequestModel request) async {
    if (isClosed || state is CreateCurriculumLoading) return;
    emit(CreateCurriculumLoading());

    final result = await curriculumManagementRepo.createCurriculum(request);
    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateCurriculumFailure(failure.message)),
      (curriculum) => emit(CreateCurriculumSuccess(curriculum)),
    );
  }

  Future<void> updateCurriculum({
    required String curriculumId,
    required UpdateCurriculumRequestModel request,
  }) async {
    if (isClosed || state is UpdateCurriculumLoading) return;
    emit(UpdateCurriculumLoading());

    final result = await curriculumManagementRepo.updateCurriculum(
      curriculumId: curriculumId,
      request: request,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(UpdateCurriculumFailure(failure.message)),
      (curriculum) => emit(UpdateCurriculumSuccess(curriculum)),
    );
  }
}
