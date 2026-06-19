import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  LoginSuccess({required this.user});

  final AuthUserModel user;
}
final class LoginPasswordVisibilityChanged extends LoginState {}

final class LoginFailure extends LoginState {
  LoginFailure({required this.errorMessage});

  final String errorMessage;
}