import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_request.dart';
import 'package:bnan_app/features/ideal_supervisor/data/repos/admin_ideal_supervisor_repo.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminIdealSupervisorCubit extends Cubit<AdminIdealSupervisorState> {
  AdminIdealSupervisorCubit(this.supervisorsRepo, this.issueRepo)
    : super(const AdminIdealSupervisorState());
  final SupervisorAssignmentRepo supervisorsRepo;
  final AdminIdealSupervisorRepo issueRepo;

  Future<void> load() async {
    if (isClosed || state.isSubmitting) return;
    emit(state.copyWith(status: AdminIdealSupervisorStatus.loading));
    final result = await supervisorsRepo.getSupervisors();
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: AdminIdealSupervisorStatus.failure,
            message: failure.message,
            errorCode: failure.code,
          ),
        );
      },
      (response) {
        if (isClosed) return;
        emit(
          AdminIdealSupervisorState(
            status: AdminIdealSupervisorStatus.loaded,
            supervisors: response.data
                .where((item) => item.id.isNotEmpty)
                .toList(),
          ),
        );
      },
    );
  }

  void toggle(String id) {
    if (isClosed || id.isEmpty || state.isSubmitting) return;
    final selected = {...state.selectedIds};
    selected.contains(id) ? selected.remove(id) : selected.add(id);
    emit(state.copyWith(selectedIds: selected));
  }

  Future<void> submit(String signerName) async {
    if (isClosed || state.selectedIds.isEmpty || state.isSubmitting) return;
    emit(state.copyWith(status: AdminIdealSupervisorStatus.submitting));
    final result = await issueRepo.issueIdealSupervisors(
      IdealSupervisorRequest(
        supervisorIds: state.selectedIds.toList(growable: false),
        signerName: signerName,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: AdminIdealSupervisorStatus.failure,
            message: failure.message,
            errorCode: failure.code,
          ),
        );
      },
      (_) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: AdminIdealSupervisorStatus.success,
            selectedIds: const {},
          ),
        );
      },
    );
  }
}
