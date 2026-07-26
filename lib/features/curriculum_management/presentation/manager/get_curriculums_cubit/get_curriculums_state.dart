import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';

abstract class GetCurriculumsState {}

class GetCurriculumsInitial extends GetCurriculumsState {}

class GetCurriculumsLoading extends GetCurriculumsState {}

class GetCurriculumsSuccess extends GetCurriculumsState {
  GetCurriculumsSuccess(this.curriculums);

  final List<CurriculumModel> curriculums;
}

class GetCurriculumsFailure extends GetCurriculumsState {
  GetCurriculumsFailure(this.message);

  final String message;
}
