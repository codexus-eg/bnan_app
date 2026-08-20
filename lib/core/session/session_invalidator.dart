import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';

class SessionInvalidator {
  SessionInvalidator._();
  static final instance = SessionInvalidator._();

  final _expired = StreamController<String?>.broadcast();
  Future<void>? _invalidation;
  bool _invalidated = false;

  Stream<String?> get expired => _expired.stream;
  bool get isInvalidating => _invalidation != null;

  Future<void> invalidate() => _invalidate(null);

  Future<void> invalidateSubscriptionAccess(String code) => _invalidate(code);

  Future<void> _invalidate(String? reason) {
    final active = _invalidation;
    if (active != null) return active;
    if (_invalidated && SessionManager.instance.accessToken == null) {
      return Future<void>.value();
    }
    _invalidated = true;
    final operation = _perform(reason);
    _invalidation = operation;
    return operation.whenComplete(() {
      if (identical(_invalidation, operation)) _invalidation = null;
    });
  }

  Future<void> _perform(String? reason) async {
    await SessionManager.instance.clearSession();
    _expired.add(reason);
  }
}
