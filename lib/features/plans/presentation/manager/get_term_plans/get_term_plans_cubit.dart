import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTermPlansCubit extends Cubit<GetTermPlansState> {
  GetTermPlansCubit(this.plansRepo) : super(GetTermPlansInitial());

  final PlansRepo plansRepo;
  String? _activeClassroomId;
  int _requestId = 0;

  Future<void> getTermPlans({required String classroomId}) async {
    _activeClassroomId = classroomId;
    final requestId = ++_requestId;
    emit(GetTermPlansLoading());

    final result = await plansRepo.getTermPlans(classroomId: classroomId);
    if (isClosed ||
        requestId != _requestId ||
        _activeClassroomId != classroomId) {
      return;
    }

    result.fold(
      (failure) => emit(GetTermPlansFailure(failure.message)),
      (response) => emit(GetTermPlansSuccess(response)),
    );
  }
}
