import 'dart:convert';

import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:crypto/crypto.dart';

class ParentPaymentAttempt {
  ParentPaymentAttempt(this.generator);
  final IdempotencyKeyGenerator generator;
  String? _fingerprint;
  String? _key;

  String keyFor(Map<String, dynamic> payload) {
    final fingerprint = fingerprintFor(payload);
    if (_key == null || _fingerprint != fingerprint) {
      _fingerprint = fingerprint;
      _key = generator.create();
    }
    return _key!;
  }

  String fingerprintFor(Map<String, dynamic> payload) =>
      sha256.convert(utf8.encode(jsonEncode(payload))).toString();

  void restore({required String fingerprint, required String key}) {
    if (fingerprint.isEmpty || key.isEmpty) return;
    _fingerprint = fingerprint;
    _key = key;
  }

  void startNew() {
    _fingerprint = null;
    _key = null;
  }
}
