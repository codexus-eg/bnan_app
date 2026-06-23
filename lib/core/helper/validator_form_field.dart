import 'package:bnan_app/generated/l10n.dart';

abstract class MyValidator {
  static String? requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return S.current.fieldIsRequired(fieldName);
    }
    return null;
  }

  static String? minLengthValidator({
    required String? value,
    required int minLength,
    required String emptyMessage,
    required String minMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage;
    }
    if (value.trim().length < minLength) {
      return minMessage;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.nameCannotBeEmpty;
    }
    if (value.trim().length < 3) {
      return S.current.nameMinLength;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.emailCannotBeEmpty;
    }

    final emailValid = RegExp(
      r"^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$",
    ).hasMatch(value.trim());

    if (!emailValid) {
      return S.current.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.passwordCannotBeEmpty;
    }
    if (value.trim().length < 8) {
      return S.current.passwordMinLength;
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.passwordCannotBeEmpty;
    }
    if (value.trim().length < 8) {
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
    if (value == null || value.trim().isEmpty) {
      return S.current.confirmPasswordCannotBeEmpty;
    }
    if (value != passwordValue) {
      return S.current.passwordsDoNotMatch;
    }
    return null;
  }
}
