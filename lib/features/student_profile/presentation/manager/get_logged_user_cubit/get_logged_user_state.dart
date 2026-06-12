import 'package:bnan_app/features/student_profile/data/models/logged_user_model.dart';

abstract class GetLoggedUserState {}

class GetLoggedUserInitial extends GetLoggedUserState {}

class GetLoggedUserLoading extends GetLoggedUserState {}

class GetLoggedUserSuccess extends GetLoggedUserState {
  final LoggedUserModel loggedUser;
  final bool isFromCache;
  final bool isRefreshing;

  GetLoggedUserSuccess({
    required this.loggedUser,
    this.isFromCache = false,
    this.isRefreshing = false,
  });
}

class GetLoggedUserFailure extends GetLoggedUserState {
  final String errorMessage;

  GetLoggedUserFailure({required this.errorMessage});
}