import 'package:bnan_app/features/teacher_assignment/data/model/teacher_grades_response_model.dart';

sealed class GetTeacherGradesState {}

final class GetTeacherGradesInitial extends GetTeacherGradesState {}

final class GetTeacherGradesLoading extends GetTeacherGradesState {}

final class GetTeacherGradesSuccess extends GetTeacherGradesState {
  final TeacherGradesResponseModel grades;

  GetTeacherGradesSuccess({required this.grades});
}

final class GetTeacherGradesFailure extends GetTeacherGradesState {
  final String errorMessage;

  GetTeacherGradesFailure({required this.errorMessage});
}