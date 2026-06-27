import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';

sealed class GetTeacherClassroomsState {}

final class GetTeacherClassroomsInitial extends GetTeacherClassroomsState {}

final class GetTeacherClassroomsLoading extends GetTeacherClassroomsState {}

final class GetTeacherClassroomsSuccess extends GetTeacherClassroomsState {
  final TeacherClassroomsResponseModel classrooms;

  GetTeacherClassroomsSuccess({required this.classrooms});
}

final class GetTeacherClassroomsFailure extends GetTeacherClassroomsState {
  final String errorMessage;

  GetTeacherClassroomsFailure({required this.errorMessage});
}