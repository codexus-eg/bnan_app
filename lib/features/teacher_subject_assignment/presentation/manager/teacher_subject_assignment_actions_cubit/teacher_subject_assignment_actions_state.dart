part of 'teacher_subject_assignment_actions_cubit.dart';

abstract class TeacherSubjectAssignmentActionsState {
  const TeacherSubjectAssignmentActionsState();
}

class TeacherSubjectAssignmentActionsInitial
    extends TeacherSubjectAssignmentActionsState {
  const TeacherSubjectAssignmentActionsInitial();
}

class AssignCurriculumsLoading extends TeacherSubjectAssignmentActionsState {
  const AssignCurriculumsLoading();
}

class AssignCurriculumsSuccess extends TeacherSubjectAssignmentActionsState {
  const AssignCurriculumsSuccess({required this.response});

  final AssignCurriculumsResponseModel response;
}

class AssignCurriculumsFailure extends TeacherSubjectAssignmentActionsState {
  const AssignCurriculumsFailure(this.message);

  final String message;
}

class AssignTeacherLoading extends TeacherSubjectAssignmentActionsState {
  const AssignTeacherLoading();
}

class AssignTeacherSuccess extends TeacherSubjectAssignmentActionsState {
  const AssignTeacherSuccess({required this.response});

  final AssignTeacherResponseModel response;
}

class AssignTeacherFailure extends TeacherSubjectAssignmentActionsState {
  const AssignTeacherFailure(this.errorMessage);

  final String errorMessage;
}

class UnassignTeacherLoading extends TeacherSubjectAssignmentActionsState {
  const UnassignTeacherLoading(this.teacherId, this.classroomId);

  final String teacherId;
  final String classroomId;
}

class UnassignTeacherSuccess extends TeacherSubjectAssignmentActionsState {
  const UnassignTeacherSuccess(this.teacherId, this.classroomId, this.response);

  final String teacherId;
  final String classroomId;
  final UnassignTeacherResponseModel response;
}

class UnassignTeacherFailure extends TeacherSubjectAssignmentActionsState {
  const UnassignTeacherFailure(
    this.teacherId,
    this.classroomId,
    this.errorMessage,
  );

  final String teacherId;
  final String classroomId;
  final String errorMessage;
}
