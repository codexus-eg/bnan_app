import 'package:bnan_app/features/student_auth/data/models/grade_model.dart';

abstract class GetGradesState {}

class GetGradesInitial extends GetGradesState {}

class GetGradesLoading extends GetGradesState {}

class GetGradesSuccess extends GetGradesState {
  final List<GradeModel> grades;

  GetGradesSuccess({required this.grades});
}

class GetGradesFailure extends GetGradesState {
  final String errorMessage;

  GetGradesFailure({required this.errorMessage});
}