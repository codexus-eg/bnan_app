import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';

sealed class GetSubjectsState {}

final class GetSubjectsInitial extends GetSubjectsState {}

final class GetSubjectsLoading extends GetSubjectsState {}

final class GetSubjectsSuccess extends GetSubjectsState {
  final List<SubjectModel> subjects;

  GetSubjectsSuccess({required this.subjects});
}

final class GetSubjectsLoadingMore extends GetSubjectsState {
  GetSubjectsLoadingMore({required this.subjects});

  final List<SubjectModel> subjects;
}

final class GetSubjectsLoadMoreFailure extends GetSubjectsState {
  GetSubjectsLoadMoreFailure({required this.subjects, required this.message});

  final List<SubjectModel> subjects;
  final String message;
}

final class GetSubjectsFailure extends GetSubjectsState {
  final String errorMessage;

  GetSubjectsFailure({required this.errorMessage});
}
