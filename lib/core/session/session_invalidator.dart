import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';

class SessionInvalidator {
  SessionInvalidator._();
  static final instance = SessionInvalidator._();

  final _expired = StreamController<void>.broadcast();
  Future<void>? _invalidation;
  bool _invalidated = false;

  Stream<void> get expired => _expired.stream;
  bool get isInvalidating => _invalidation != null;

  Future<void> invalidate() {
    final active = _invalidation;
    if (active != null) return active;
    if (_invalidated && SessionManager.instance.accessToken == null) {
      return Future<void>.value();
    }
    _invalidated = true;
    final operation = _perform();
    _invalidation = operation;
    return operation.whenComplete(() {
      if (identical(_invalidation, operation)) _invalidation = null;
    });
  }

  Future<void> _perform() async {
    await SessionManager.instance.clearSession();
    _expired.add(null);
  }
}
