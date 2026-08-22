import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';

sealed class TeacherDetailsState {}

final class TeacherDetailsInitial extends TeacherDetailsState {}

final class TeacherDetailsLoading extends TeacherDetailsState {}

final class TeacherDetailsSuccess extends TeacherDetailsState {
  final TeacherDetailsResponseModel response;

  TeacherDetailsSuccess(this.response);
}

final class TeacherDetailsFailure extends TeacherDetailsState {
  final String message;

  TeacherDetailsFailure(this.message);
}
