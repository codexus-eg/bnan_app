import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSupervisorClassroomsCubit extends Cubit<GetSupervisorClassroomsState> {
  GetSupervisorClassroomsCubit(this.supervisorManagementRepo)
    : super(GetSupervisorClassroomsInitial());

  final SupervisorManagementRepo supervisorManagementRepo;

  Future<void> getMyClassrooms() async {
    emit(GetSupervisorClassroomsLoading());
    final result = await supervisorManagementRepo.getMyClassrooms();
    if (isClosed) return;

    result.fold(
      (failure) => emit(GetSupervisorClassroomsFailure(failure.message)),
      (response) => emit(GetSupervisorClassroomsSuccess(response)),
    );
  }
}
