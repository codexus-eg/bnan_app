import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTermPlansCubit extends Cubit<GetTermPlansState> {
  GetTermPlansCubit(this.plansRepo) : super(GetTermPlansInitial());

  final PlansRepo plansRepo;
  String? selectedClassroomId;
  int _requestId = 0;

  Future<void> getAllTermPlans({String? classroomId}) async {
    if (isClosed) return;
    final id = classroomId?.trim();
    selectedClassroomId = id == null || id.isEmpty ? null : id;
    final requestId = ++_requestId;
    emit(GetTermPlansLoading());
    final result = await plansRepo.getAllTermPlans(
      classroomId: selectedClassroomId,
    );
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(GetTermPlansFailure(failure.message)),
      (response) => emit(GetTermPlansSuccess(response)),
    );
  }

  Future<void> selectClassroom(String? classroomId) =>
      getAllTermPlans(classroomId: classroomId);

  Future<void> refresh() => getAllTermPlans(classroomId: selectedClassroomId);

  Future<void> getTermPlans({required String classroomId}) async {
    if (isClosed) return;
    final requestId = ++_requestId;
    emit(GetTermPlansLoading());

    final result = await plansRepo.getTermPlans(classroomId: classroomId);
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) => emit(GetTermPlansFailure(failure.message)),
      (response) => emit(GetTermPlansSuccess(response)),
    );
  }
}
