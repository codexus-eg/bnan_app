import 'package:bnan_app/features/teacher_assignment/data/model/create_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/update_assignment/update_assignment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateAssignmentCubit extends Cubit<UpdateAssignmentState> {
  UpdateAssignmentCubit(this.assignmentsRepo) : super(UpdateAssignmentInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> updateAssignment({
    required String assignmentId,
    required CreateAssignmentRequestModel request,
  }) async {
    emit(UpdateAssignmentLoading());

    final result = await assignmentsRepo.updateAssignment(
      assignmentId: assignmentId,
      request: request,
    );

    result.fold(
      (failure) {
        emit(UpdateAssignmentFailure(errorMessage: failure.message));
      },
      (assignment) {
        emit(UpdateAssignmentSuccess(assignment: assignment));
      },
    );
  }
}