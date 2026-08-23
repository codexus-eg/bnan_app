import 'package:flutter/foundation.dart';

abstract final class GulfRenewalTrace {
  static final Map<String, int> _counts = {};

  static void log(String event, {String details = ''}) {
    if (!kDebugMode) return;
    final count = (_counts[event] ?? 0) + 1;
    _counts[event] = count;
    debugPrint(
      '[GulfRenewalTrace] $event count=$count'
      '${details.isEmpty ? '' : ' $details'}',
    );
  }
}
