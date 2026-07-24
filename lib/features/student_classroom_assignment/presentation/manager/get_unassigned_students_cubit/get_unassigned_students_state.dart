import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';

sealed class GetUnassignedStudentsState {
  const GetUnassignedStudentsState();
}

final class GetUnassignedStudentsInitial
    extends GetUnassignedStudentsState {
  const GetUnassignedStudentsInitial();
}

final class GetUnassignedStudentsLoading
    extends GetUnassignedStudentsState {
  const GetUnassignedStudentsLoading();
}

final class GetUnassignedStudentsSuccess
    extends GetUnassignedStudentsState {
  const GetUnassignedStudentsSuccess(this.students);

  final List<UnassignedStudentModel> students;
}

final class GetUnassignedStudentsFailure
    extends GetUnassignedStudentsState {
  const GetUnassignedStudentsFailure(this.message);

  final String message;
}