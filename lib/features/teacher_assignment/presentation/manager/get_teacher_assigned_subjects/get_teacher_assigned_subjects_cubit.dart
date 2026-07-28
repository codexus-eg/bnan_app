import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherAssignedSubjectsCubit
    extends Cubit<GetTeacherAssignedSubjectsState> {
  GetTeacherAssignedSubjectsCubit(this.assignmentsRepo)
    : super(GetTeacherAssignedSubjectsInitial());

  final AssignmentsRepo assignmentsRepo;
  String? _activeClassroomId;
  int _requestId = 0;

  Future<void> getTeacherAssignedSubjects({required String classroomId}) async {
    _activeClassroomId = classroomId;
    final requestId = ++_requestId;
    emit(GetTeacherAssignedSubjectsLoading());

    final result = await assignmentsRepo.getTeacherAssignedSubjects(
      classroomId: classroomId,
    );

    if (isClosed ||
        requestId != _requestId ||
        _activeClassroomId != classroomId) {
      return;
    }

    result.fold(
      (failure) => emit(
        GetTeacherAssignedSubjectsFailure(errorMessage: failure.message),
      ),
      (response) => emit(GetTeacherAssignedSubjectsSuccess(response: response)),
    );
  }

  void clear() {
    _requestId++;
    _activeClassroomId = null;
    if (!isClosed) emit(GetTeacherAssignedSubjectsInitial());
  }
}
