import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';

sealed class GetStudentSubjectsState {}

final class GetStudentSubjectsInitial
    extends GetStudentSubjectsState {}

final class GetStudentSubjectsLoading
    extends GetStudentSubjectsState {}

final class GetStudentSubjectsSuccess
    extends GetStudentSubjectsState {
  GetStudentSubjectsSuccess(this.response);

  final StudentSubjectsResponseModel response;
}

final class GetStudentSubjectsFailure
    extends GetStudentSubjectsState {
  GetStudentSubjectsFailure(this.message);

  final String message;
}