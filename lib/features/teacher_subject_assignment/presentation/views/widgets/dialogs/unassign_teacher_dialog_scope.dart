import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';

class UnassignTeacherDialogScope {
  const UnassignTeacherDialogScope({
    required this.teacherId,
    required this.classroomId,
  });

  final String teacherId;
  final String classroomId;

  bool isLoading(TeacherSubjectAssignmentActionsState state) =>
      state is UnassignTeacherLoading &&
      _matches(state.teacherId, state.classroomId);

  bool isSuccess(TeacherSubjectAssignmentActionsState state) =>
      state is UnassignTeacherSuccess &&
      _matches(state.teacherId, state.classroomId);

  String? errorFrom(TeacherSubjectAssignmentActionsState state) {
    return state is UnassignTeacherFailure &&
            _matches(state.teacherId, state.classroomId)
        ? state.errorMessage
        : null;
  }

  bool _matches(String stateTeacherId, String stateClassroomId) =>
      stateTeacherId == teacherId.trim() &&
      stateClassroomId == classroomId.trim();
}
