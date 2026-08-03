import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';

sealed class GetSupervisorsState {
  const GetSupervisorsState();
}

final class GetSupervisorsInitial extends GetSupervisorsState {
  const GetSupervisorsInitial();
}

final class GetSupervisorsLoading extends GetSupervisorsState {
  const GetSupervisorsLoading();
}

final class GetSupervisorsSuccess extends GetSupervisorsState {
  const GetSupervisorsSuccess(this.supervisors);

  final List<SupervisorModel> supervisors;
}

final class GetSupervisorsFailure extends GetSupervisorsState {
  const GetSupervisorsFailure(this.errorMessage);

  final String errorMessage;
}
