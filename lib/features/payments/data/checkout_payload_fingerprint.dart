import 'dart:convert';

import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:crypto/crypto.dart';

String checkoutPayloadFingerprint(TamaraCheckoutRequest request) {
  return checkoutMapFingerprint(request.toJson());
}

String checkoutMapFingerprint(Map<String, dynamic> payload) {
  final payloadBytes = utf8.encode(jsonEncode(payload));
  return sha256.convert(payloadBytes).toString();
}
