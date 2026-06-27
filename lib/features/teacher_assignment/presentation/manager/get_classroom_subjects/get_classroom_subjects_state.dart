import 'package:bnan_app/features/teacher_assignment/data/model/classroom_subjects_response_model.dart';

sealed class GetClassroomSubjectsState {}

final class GetClassroomSubjectsInitial extends GetClassroomSubjectsState {}

final class GetClassroomSubjectsLoading extends GetClassroomSubjectsState {}

final class GetClassroomSubjectsSuccess extends GetClassroomSubjectsState {
  final ClassroomSubjectsResponseModel classroomSubjects;

  GetClassroomSubjectsSuccess({required this.classroomSubjects});
}

final class GetClassroomSubjectsFailure extends GetClassroomSubjectsState {
  final String errorMessage;

  GetClassroomSubjectsFailure({required this.errorMessage});
}