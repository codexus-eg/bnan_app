import 'package:bnan_app/features/student_classroom_assignment/data/models/assign_student_response_model.dart';

sealed class AssignStudentState {
  const AssignStudentState();
}

final class AssignStudentInitial extends AssignStudentState {
  const AssignStudentInitial();
}

final class AssignStudentLoading extends AssignStudentState {
  const AssignStudentLoading();
}

final class AssignStudentSuccess extends AssignStudentState {
  const AssignStudentSuccess(this.response);

  final AssignStudentResponseModel response;
}

final class AssignStudentFailure extends AssignStudentState {
  const AssignStudentFailure(this.message);

  final String message;
}
