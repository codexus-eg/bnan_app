import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

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
    
    String? backendMessage;
    try {
      if (error.response?.data != null && error.response?.data is Map) {
        backendMessage = error.response!.data['message']?.toString();
      }
    } catch (_) {
    }

    if (backendMessage != null && backendMessage.isNotEmpty) {
        return AppException(backendMessage);
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
      case 500:
        return AppException(S.current.errorInternalServer);
      default:
        return AppException(S.current.errorUnknownStatusCode(statusCode?.toString() ?? '??'));
    }
  }

  @override
  String toString() => message;
}