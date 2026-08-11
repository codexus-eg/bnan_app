import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/generated/l10n.dart';

abstract class ParentAddChildValidation {
  static String? currentStep(ParentAddChildState state) =>
      switch (state.currentStep) {
        0 => _account(state),
        1 => state.grade == null ? S.current.selectGrade : null,
        2 => state.package == null ? S.current.invalidPackage : null,
        3 => _subjects(state),
        5 => _payment(state),
        _ => null,
      };

  static String? _account(ParentAddChildState state) {
    if (state.fullName.trim().length < 3) return S.current.nameCannotBeEmpty;
    final email = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$");
    if (!email.hasMatch(state.email.trim())) return S.current.invalidEmail;
    if (state.password.length < 8) return S.current.passwordMinLength;
    if (state.password != state.confirmPassword) {
      return S.current.passwordsDoNotMatch;
    }
    return null;
  }

  static String? _subjects(ParentAddChildState state) {
    final count = state.selectedSubjectIds.length;
    if (state.isSingleSubject && count != 1) {
      return S.current.parentSingleSubjectRequired;
    }
    if (!state.isSingleSubject && count < 1) {
      return S.current.pleaseChooseAtLeastOneSubjectForEachGrade;
    }
    return null;
  }

  static String? _payment(ParentAddChildState state) {
    if (!state.isGulf && state.receipt == null) {
      return S.current.paymentReceiptRequired;
    }
    if (state.isGulf &&
        [
          state.city,
          state.region,
          state.addressLine1,
        ].any((value) => value.trim().isEmpty)) {
      return S.current.parentPaymentAddressRequired;
    }
    return null;
  }
}
