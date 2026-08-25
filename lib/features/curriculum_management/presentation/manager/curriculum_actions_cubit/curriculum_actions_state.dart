import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';

abstract class CurriculumActionsState {}

class CurriculumActionsInitial extends CurriculumActionsState {}

class CreateCurriculumLoading extends CurriculumActionsState {}

class CreateCurriculumSuccess extends CurriculumActionsState {
  CreateCurriculumSuccess(this.curriculum);

  final CurriculumModel curriculum;
}

class CreateCurriculumFailure extends CurriculumActionsState {
  CreateCurriculumFailure(this.message);

  final String message;
}

class UpdateCurriculumLoading extends CurriculumActionsState {}

class UpdateCurriculumSuccess extends CurriculumActionsState {
  UpdateCurriculumSuccess(this.curriculum);

  final CurriculumModel curriculum;
}

class UpdateCurriculumFailure extends CurriculumActionsState {
  UpdateCurriculumFailure(this.message);

  final String message;
}

class DeleteCurriculumLoading extends CurriculumActionsState {}

class DeleteCurriculumSuccess extends CurriculumActionsState {
  DeleteCurriculumSuccess(this.curriculumId);

  final String curriculumId;
}

class DeleteCurriculumFailure extends CurriculumActionsState {
  DeleteCurriculumFailure(this.message);

  final String message;
}
