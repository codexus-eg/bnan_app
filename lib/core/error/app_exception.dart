import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';

class AppException implements Exception {
  const AppException(this.message);

  final String message;

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

    final backendMessage = _extractBackendMessage(data);
    if (backendMessage != null) {
      return AppException(_safeBackendMessage(backendMessage));
    }

    final validationMessage = _extractValidationMessage(data);
    if (validationMessage != null) {
      return AppException(_safeBackendMessage(validationMessage));
    }

    switch (statusCode) {
      case 400:
        return AppException(S.current.errorBadRequest);
      case 401:
        return AppException(S.current.errorUnauthorized);
      case 403:
        return AppException(S.current.errorForbidden);
      case 404:
        return AppException(S.current.errorNotFound);
      case 422:
        return AppException(S.current.errorValidation);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppException(S.current.errorInternalServer);
      default:
        return AppException(
          S.current.errorUnknownStatusCode(statusCode?.toString() ?? '??'),
        );
    }
  }

  static String? _extractBackendMessage(dynamic data) {
    if (data is! Map) return null;

    final message = data['message'] ?? data['error'] ?? data['code'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    return null;
  }

  static String? _extractValidationMessage(dynamic data) {
    if (data is! Map) return null;

    final errors = data['errors'];

    const technicalIdKeys = {
      'teacherId',
      'classroomId',
      'subjectId',
      'classroomSubjectId',
    };
    if (errors is Map && errors.isNotEmpty) {
      for (final entry in errors.entries) {
        if (technicalIdKeys.contains(entry.key?.toString())) continue;
        final error = entry.value;
        if (error is List && error.isNotEmpty) {
          final message = error.first.toString().trim();
          if (message.isNotEmpty) return message;
        }
        if (error is String && error.trim().isNotEmpty) {
          return error.trim();
        }
      }
    }

    return null;
  }

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
