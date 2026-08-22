import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/generated/l10n.dart';

abstract class ParentAddChildValidation {
  static String? currentStep(ParentAddChildState state) =>
      switch (state.currentStep) {
        0 => _package(state),
        1 => state.grade == null ? S.current.selectGrade : null,
        2 => _account(state),
        3 => _subjects(state),
        5 when state.isGulf => null,
        _ => null,
      };

  static String? _package(ParentAddChildState state) {
    if (state.curriculum == null) {
      return state.parentHasChildren
          ? S.current.parentUnsupportedRegistrationMode
          : S.current.curriculumRequired;
    }
    return state.package == null ? S.current.invalidPackage : null;
  }

  static String? _account(ParentAddChildState state) {
    return MyValidator.validateName(state.fullName) ??
        MyValidator.validateEmail(state.email) ??
        MyValidator.validateRegistrationPassword(state.password);
  }

  static String? _subjects(ParentAddChildState state) {
    if (!state.requiresSubjectSelection) return null;
    final count = state.selectedSubjectIds.length;
    if (state.isSingleSubject && !state.isEgyptianPrivate && count != 1) {
      return S.current.parentSingleSubjectRequired;
    }
    if (count < 1) {
      return S.current.pleaseChooseAtLeastOneSubjectForEachGrade;
    }
    return null;
  }
}
