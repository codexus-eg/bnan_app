part of 'teacher_subject_assignment_actions_cubit.dart';

abstract class TeacherSubjectAssignmentActionsState {
  const TeacherSubjectAssignmentActionsState();
}

class TeacherSubjectAssignmentActionsInitial extends TeacherSubjectAssignmentActionsState {
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

class BulkAssignTeachingAssignmentsLoading extends TeacherSubjectAssignmentActionsState {
  const BulkAssignTeachingAssignmentsLoading();
}

class BulkAssignTeachingAssignmentsSuccess extends TeacherSubjectAssignmentActionsState {
  const BulkAssignTeachingAssignmentsSuccess({required this.response});

  final BulkAssignTeachingAssignmentsResponseModel response;
}

class BulkAssignTeachingAssignmentsFailure extends TeacherSubjectAssignmentActionsState {
  const BulkAssignTeachingAssignmentsFailure(this.message);

  final String message;
}
