import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';

class AppException implements Exception {
  const AppException(
    this.message, {
    this.responseReceived = false,
    this.statusCode,
    this.code,
  });

  final String message;
  final bool responseReceived;
  final int? statusCode;
  final String? code;

  factory AppException.fromDio(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return AppException(S.current.errorConnectionTimeout);

      case DioExceptionType.sendTimeout:
        return AppException(S.current.errorSendTimeout);

      case DioExceptionType.receiveTimeout:
        return AppException(S.current.errorReceiveTimeout);

      case DioExceptionType.badCertificate:
        return AppException(S.current.errorBadCertificate);

      case DioExceptionType.badResponse:
        return _handleBadResponse(dioError);

      case DioExceptionType.cancel:
        return AppException(S.current.errorCancel);

      case DioExceptionType.connectionError:
        return AppException(S.current.errorNoInternet);

      case DioExceptionType.unknown:
        return AppException(S.current.errorUnknown);
    }
  }

  static AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final backendCode = _extractBackendCode(data);
    AppException confirmed(String message) => AppException(
      message,
      responseReceived: true,
      statusCode: statusCode,
      code: backendCode,
    );

    final validationMessage = _extractValidationMessage(data);
    if (validationMessage != null) {
      return confirmed(_safeBackendMessage(validationMessage));
    }

    final backendMessage = _extractBackendMessage(data);
    if (backendMessage != null) {
      return confirmed(_safeBackendMessage(backendMessage));
    }

    switch (statusCode) {
      case 400:
        return confirmed(S.current.errorBadRequest);
      case 401:
        return confirmed(S.current.errorUnauthorized);
      case 403:
        return confirmed(S.current.errorForbidden);
      case 404:
        return confirmed(S.current.errorNotFound);
      case 422:
        return confirmed(S.current.errorValidation);
      case 500:
      case 502:
      case 503:
      case 504:
        return confirmed(S.current.errorInternalServer);
      default:
        return confirmed(
          S.current.errorUnknownStatusCode(statusCode?.toString() ?? '??'),
        );
    }
  }

  static String? _extractBackendMessage(dynamic data) {
    if (data is! Map) return null;
    final error = data['error'];
    if (error is Map) {
      final nested = _findText(error, const {
        'message',
        'detail',
      }, allowErrorString: true);
      if (nested != null) return nested;
    }
    return _findText(data, const {'message', 'detail'}, allowErrorString: true);
  }

  static String? _extractBackendCode(dynamic data) {
    if (data is! Map) return null;
    return _findText(data, const {'code', 'errorCode', 'error_code'});
  }

  static String? _findText(
    Map data,
    Set<String> keys, {
    bool allowErrorString = false,
    int depth = 0,
  }) {
    if (depth > 3) return null;
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    if (allowErrorString && data['error'] is String) {
      final value = (data['error'] as String).trim();
      if (value.isNotEmpty) return value;
    }
    for (final key in const ['error', 'data', 'response']) {
      final nested = data[key];
      if (nested is Map) {
        final value = _findText(
          nested,
          keys,
          allowErrorString: allowErrorString,
          depth: depth + 1,
        );
        if (value != null) return value;
      }
    }
    return null;
  }

  static String? _extractValidationMessage(dynamic data) {
    if (data is! Map) return null;

    final errors = data['errors'];

    const technicalIdKeys = {
      'teacherId',
      'studentId',
      'classroomId',
      'subjectId',
      'classroomSubjectId',
      'packageId',
      'subscriptionId',
    };
    if (errors is Map && errors.isNotEmpty) {
      for (final entry in errors.entries) {
        final error = entry.value;
        if (error is List && error.isNotEmpty) {
          final message = error.first.toString().trim();
          if (message.isNotEmpty) return message;
        }
        if (error is String && error.trim().isNotEmpty) {
          final message = error.trim();
          if (!technicalIdKeys.contains(entry.key?.toString()) ||
              !_looksLikeIdentifier(message)) {
            return message;
          }
        }
      }
    }

    return null;
  }

  static bool _looksLikeIdentifier(String value) =>
      RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(value) ||
      RegExp(r'^[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*-id$').hasMatch(value);

  static String _safeBackendMessage(String message) {
    final lowerMessage = message.toLowerCase();

    final hasTechnicalDetails =
        lowerMessage.contains('exception') ||
        lowerMessage.contains('sql') ||
        lowerMessage.contains('stack') ||
        lowerMessage.contains('trace') ||
        lowerMessage.contains('database') ||
        lowerMessage.contains('server error') ||
        lowerMessage.contains('internal server') ||
        lowerMessage.contains('query') ||
        lowerMessage.contains('syntax') ||
        lowerMessage.contains('null check') ||
        lowerMessage.contains('typeerror') ||
        lowerMessage.contains('type error');

    if (hasTechnicalDetails) {
      return S.current.errorUnknown;
    }

    return message;
  }

  @override
  String toString() => message;
}
