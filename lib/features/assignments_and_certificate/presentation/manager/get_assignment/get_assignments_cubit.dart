import 'package:bnan_app/features/assignments_and_certificate/data/repo/student_assignments_repo.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/manager/get_assignment/get_assignments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAssignmentsCubit extends Cubit<GetAssignmentsState> {
  GetAssignmentsCubit(this.repo) : super(GetAssignmentsInitial());

  final StudentAssignmentsRepo repo;

  Future<void> getMyAssignments() async {
    emit(GetAssignmentsLoading());

    final result = await repo.getMyAssignments();

    result.fold(
      (failure) => emit(GetAssignmentsFailure(errorMessage: failure.message)),
      (response) => emit(GetAssignmentsSuccess(assignments: response.assignments)),
    );
  }
}