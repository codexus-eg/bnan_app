import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';

sealed class GetSubjectsState {}

final class GetSubjectsInitial extends GetSubjectsState {}

final class GetSubjectsLoading extends GetSubjectsState {}

final class GetSubjectsSuccess extends GetSubjectsState {
  final SubjectsResponseModel subjects;

  GetSubjectsSuccess({required this.subjects});
}

final class GetSubjectsFailure extends GetSubjectsState {
  final String errorMessage;

  GetSubjectsFailure({required this.errorMessage});
}
