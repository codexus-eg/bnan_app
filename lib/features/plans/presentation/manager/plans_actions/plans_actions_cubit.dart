import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansActionsCubit extends Cubit<PlansActionsState> {
  PlansActionsCubit(this.plansRepo) : super(PlansActionsInitial());

  final PlansRepo plansRepo;
  bool _isCreatingDaily = false;
  bool _isUploadingTerm = false;

  Future<void> createDailyPlan({
    required String classroomId,
    required String subjectId,
    required CreateDailyPlanRequestModel request,
  }) async {
    if (_isCreatingDaily || isClosed) return;
    _isCreatingDaily = true;
    emit(CreateDailyPlanLoading());
    try {
      final result = await plansRepo.createDailyPlan(
        classroomId: classroomId,
        subjectId: subjectId,
        request: request,
      );
      if (isClosed) return;
      result.fold(
        (failure) => emit(CreateDailyPlanFailure(failure.message)),
        (response) => emit(CreateDailyPlanSuccess(response)),
      );
    } finally {
      _isCreatingDaily = false;
    }
  }

  Future<void> uploadTermPlan({
    required String classroomId,
    required String subjectId,
    required String attachmentPath,
  }) async {
    if (_isUploadingTerm || isClosed) return;
    _isUploadingTerm = true;
    emit(UploadTermPlanLoading());
    try {
      final result = await plansRepo.uploadTermPlan(
        classroomId: classroomId,
        subjectId: subjectId,
        attachmentPath: attachmentPath,
      );
      if (isClosed) return;
      result.fold(
        (failure) => emit(UploadTermPlanFailure(failure.message)),
        (response) => emit(UploadTermPlanSuccess(response)),
      );
    } finally {
      _isUploadingTerm = false;
    }
  }
}
