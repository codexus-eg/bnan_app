part of 'teacher_subject_assignments_cubit.dart';

abstract class TeacherSubjectAssignmentsState {
  const TeacherSubjectAssignmentsState();
}

class TeacherSubjectAssignmentsInitial extends TeacherSubjectAssignmentsState {
  const TeacherSubjectAssignmentsInitial();
}

class GetTeachingAssignmentsLoading extends TeacherSubjectAssignmentsState {
  const GetTeachingAssignmentsLoading();
}

class GetTeachingAssignmentsSuccess extends TeacherSubjectAssignmentsState {
  const GetTeachingAssignmentsSuccess({required this.assignments});

  final List<TeachingAssignmentItem> assignments;
}

class GetTeachingAssignmentsEmpty extends TeacherSubjectAssignmentsState {
  const GetTeachingAssignmentsEmpty();
}

class GetTeachingAssignmentsFailure extends TeacherSubjectAssignmentsState {
  const GetTeachingAssignmentsFailure(this.message);

  final String message;
}
