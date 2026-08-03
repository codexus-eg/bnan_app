import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_supervisors_state.dart';

class GetSupervisorsCubit extends Cubit<GetSupervisorsState> {
  GetSupervisorsCubit(this.repo) : super(const GetSupervisorsInitial());

  final SupervisorAssignmentRepo repo;

  Future<void> getSupervisors() async {
    emit(const GetSupervisorsLoading());
    final result = await repo.getSupervisors();
    result.fold(
      (failure) => emit(GetSupervisorsFailure(failure.message)),
      (response) => emit(GetSupervisorsSuccess(response.data)),
    );
  }
}
