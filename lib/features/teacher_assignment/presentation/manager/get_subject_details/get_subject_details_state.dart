import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';

sealed class GetSubjectDetailsState {}

final class GetSubjectDetailsInitial extends GetSubjectDetailsState {}

final class GetSubjectDetailsLoading extends GetSubjectDetailsState {}

final class GetSubjectDetailsSuccess extends GetSubjectDetailsState {
  final List<SubjectDetailsModel> subjects;

  GetSubjectDetailsSuccess({required this.subjects});
}

final class GetSubjectDetailsFailure extends GetSubjectDetailsState {
  final String errorMessage;

  GetSubjectDetailsFailure({required this.errorMessage});
}