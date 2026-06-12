import 'package:bnan_app/generated/l10n.dart';

abstract class MyValidator {
  static String? requiredValidator(String? value, String message) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.nameCannotBeEmpty;
    }
    if (value.length < 3) {
      return S.current.nameMinLength;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.emailCannotBeEmpty;
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
    if (!emailValid) {
      return S.current.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.passwordCannotBeEmpty;
    }
    if (value.length < 8) {
      return S.current.passwordMinLength;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return S.current.passwordMustHaveUpperCase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return S.current.passwordMustHaveNumber;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String passwordValue) {
    if (value == null || value.isEmpty) {
      return S.current.confirmPasswordCannotBeEmpty;
    }
    if (value != passwordValue) {
      return S.current.passwordsDoNotMatch;
    }
    return null;
  }
}
