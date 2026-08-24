import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:flutter/foundation.dart';

abstract final class GulfRegistrationDiagnostics {
  static String? lastEndpoint;

  static void started(String endpoint) {
    lastEndpoint = endpoint;
    _log('calling endpoint=$endpoint; request started');
  }

  static void succeeded(String endpoint, {int? statusCode}) => _log(
    'endpoint=$endpoint; statusCode=${statusCode ?? 'not_exposed'}; succeeded',
  );

  static void checkoutPayload(Map<String, dynamic> payload) => _log(
    'checkout payload keys=${payload.keys.toList()}; '
    'items=${payload['items']}',
  );

  static void failed(String endpoint, Object error, {int? statusCode}) {
    lastEndpoint = endpoint;
    final exception = error is AppException ? error : null;
    final failure = error is Failure ? error : null;
    _log(
      'FAILED endpoint=$endpoint; exceptionType=${error.runtimeType}; '
      'statusCode=${statusCode ?? exception?.statusCode ?? failure?.statusCode}; '
      'backendCode=${exception?.code ?? failure?.code}; '
      'backendMessage=${_safe(exception?.message ?? failure?.message ?? error.toString())}',
    );
  }

  static void uiFailure({
    required String endpoint,
    required String cubit,
    required String state,
    required String message,
  }) => _log(
    'UI failure source; endpoint=$endpoint; cubit=$cubit; state=$state; '
    'message=${_safe(message)}',
  );

  static String _safe(String value) => value
      .replaceAll(RegExp(r'[\w.%-]+@[\w.-]+\.[A-Za-z]{2,}'), '[email]')
      .replaceAll(RegExp(r'\+?\d[\d\s-]{7,}\d'), '[number]');

  static void _log(String message) {
    if (kDebugMode) debugPrint('[GulfRegister] $message');
  }
}
