import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';

sealed class GetAvailableClassroomsState {
  const GetAvailableClassroomsState();
}

final class GetAvailableClassroomsInitial
    extends GetAvailableClassroomsState {
  const GetAvailableClassroomsInitial();
}

final class GetAvailableClassroomsLoading
    extends GetAvailableClassroomsState {
  const GetAvailableClassroomsLoading();
}

final class GetAvailableClassroomsSuccess
    extends GetAvailableClassroomsState {
  const GetAvailableClassroomsSuccess(this.response);

  final AvailableClassroomsResponseModel response;
}

final class GetAvailableClassroomsFailure
    extends GetAvailableClassroomsState {
  const GetAvailableClassroomsFailure(this.message);

  final String message;
}
