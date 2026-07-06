import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';

sealed class ClassroomDetailsState {}

final class ClassroomDetailsInitial extends ClassroomDetailsState {}

final class ClassroomDetailsLoading extends ClassroomDetailsState {}

final class ClassroomDetailsSuccess extends ClassroomDetailsState {
  final ClassroomDetailsResponseModel response;

  ClassroomDetailsSuccess(this.response);
}

final class ClassroomDetailsFailure extends ClassroomDetailsState {
  final String message;

  ClassroomDetailsFailure(this.message);
}
