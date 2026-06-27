import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';

abstract class StudentProfileState {}

class StudentProfileStateInitial extends StudentProfileState {}

class StudentProfileStateLoading extends StudentProfileState {}

class StudentProfileStateSuccess extends StudentProfileState {
  final LoggedUserModel loggedUser;
  final bool isFromCache;
  final bool isRefreshing;

  StudentProfileStateSuccess({
    required this.loggedUser,
    this.isFromCache = false,
    this.isRefreshing = false,
  });
}

class StudentProfileStateFailure extends StudentProfileState {
  final String errorMessage;

  StudentProfileStateFailure({required this.errorMessage});
}