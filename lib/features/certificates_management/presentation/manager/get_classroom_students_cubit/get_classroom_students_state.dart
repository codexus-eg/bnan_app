import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';

sealed class GetClassroomStudentsState {}

final class GetClassroomStudentsInitial
    extends GetClassroomStudentsState {}

final class GetClassroomStudentsLoading
    extends GetClassroomStudentsState {}

final class GetClassroomStudentsSuccess
    extends GetClassroomStudentsState {
  GetClassroomStudentsSuccess(this.response);

  final ClassroomStudentsResponseModel response;
}

final class GetClassroomStudentsFailure
    extends GetClassroomStudentsState {
  GetClassroomStudentsFailure(this.message);

  final String message;
}