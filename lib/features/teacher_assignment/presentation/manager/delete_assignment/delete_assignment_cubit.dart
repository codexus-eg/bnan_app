import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/delete_assignment/delete_assignment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAssignmentCubit extends Cubit<DeleteAssignmentState> {
  DeleteAssignmentCubit(this.assignmentsRepo) : super(DeleteAssignmentInitial());

  final AssignmentsRepo assignmentsRepo;
static DeleteAssignmentCubit get(context)=> BlocProvider.of(context);
  Future<void> deleteAssignment({required String assignmentId}) async {
    emit(DeleteAssignmentLoading());

    final result = await assignmentsRepo.deleteAssignment(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) {
        emit(DeleteAssignmentFailure(errorMessage: failure.message));
      },
      (_) {
        emit(DeleteAssignmentSuccess());
      },
    );
  }
}