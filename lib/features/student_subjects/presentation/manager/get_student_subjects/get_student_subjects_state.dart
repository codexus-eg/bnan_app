import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';

sealed class GetMySubjectsState {}

final class GetMySubjectsInitial extends GetMySubjectsState {}

final class GetMySubjectsLoading extends GetMySubjectsState {}

final class GetMySubjectsSuccess extends GetMySubjectsState {
  GetMySubjectsSuccess(this.subjects);

  final List<StudentSubjectModel> subjects;
}

final class GetMySubjectsEmpty extends GetMySubjectsState {}

final class GetMySubjectsFailure extends GetMySubjectsState {
  GetMySubjectsFailure(this.message);

  final String message;
}

final class GetMySubjectsUnauthorized extends GetMySubjectsState {}
