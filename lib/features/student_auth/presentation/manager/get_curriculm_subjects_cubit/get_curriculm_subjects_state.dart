import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';

abstract class GetCurriculmSubjectsState {}

class GetSubjectsInitial extends GetCurriculmSubjectsState {}

class GetSubjectsLoading extends GetCurriculmSubjectsState {}

class GetSubjectsSuccess extends GetCurriculmSubjectsState {
  final List<SubjectModel> subjects;

  GetSubjectsSuccess({required this.subjects});
}

class GetSubjectsFailure extends GetCurriculmSubjectsState {
  final String errorMessage;

  GetSubjectsFailure({required this.errorMessage});
}