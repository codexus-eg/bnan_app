import 'package:bnan_app/features/auth/data/models/curriculum_model.dart';

abstract class GetCurriculumsState {}

class GetCurriculumsInitial extends GetCurriculumsState {}

class GetCurriculumsLoading extends GetCurriculumsState {}

class GetCurriculumsSuccess extends GetCurriculumsState {
  final List<CurriculumModel> curriculums;

  GetCurriculumsSuccess({required this.curriculums});
}

class GetCurriculumsFailure extends GetCurriculumsState {
  final String errorMessage;

  GetCurriculumsFailure({required this.errorMessage});
}