import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';

abstract class GetSubjectsState {}

class GetSubjectsInitial extends GetSubjectsState {}

class GetSubjectsLoading extends GetSubjectsState {}

class GetSubjectsSuccess extends GetSubjectsState {
  final List<SubjectModel> subjects;

  GetSubjectsSuccess({required this.subjects});
}

class GetSubjectsFailure extends GetSubjectsState {
  final String errorMessage;

  GetSubjectsFailure({required this.errorMessage});
}