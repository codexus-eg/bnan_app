import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';

sealed class ClassroomsState {}

final class ClassroomsInitial extends ClassroomsState {}

final class ClassroomsLoading extends ClassroomsState {}

final class ClassroomsSuccess extends ClassroomsState {
  final ClassroomsResponseModel response;

  ClassroomsSuccess(this.response);
}

final class ClassroomsFailure extends ClassroomsState {
  final String message;

  ClassroomsFailure(this.message);
}
