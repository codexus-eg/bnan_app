import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_response_model.dart';

sealed class GetTeacherCurriculumsState {}

final class GetTeacherCurriculumsInitial extends GetTeacherCurriculumsState {}

final class GetTeacherCurriculumsLoading extends GetTeacherCurriculumsState {}

final class GetTeacherCurriculumsSuccess extends GetTeacherCurriculumsState {
  final TeacherCurriculumsResponseModel curriculums;

  GetTeacherCurriculumsSuccess({required this.curriculums});
}

final class GetTeacherCurriculumsFailure extends GetTeacherCurriculumsState {
  final String errorMessage;

  GetTeacherCurriculumsFailure({required this.errorMessage});
}