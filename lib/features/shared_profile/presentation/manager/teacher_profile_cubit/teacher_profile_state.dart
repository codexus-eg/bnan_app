import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';

abstract class TeacherProfileState {}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileSuccess extends TeacherProfileState {
  final TeacherProfileModel teacherProfile;

  TeacherProfileSuccess({required this.teacherProfile});
}

class TeacherProfileFailure extends TeacherProfileState {
  final String errorMessage;

  TeacherProfileFailure({required this.errorMessage});
}