import 'dart:convert';

import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:crypto/crypto.dart';

String checkoutPayloadFingerprint(TamaraCheckoutRequest request) {
  final payloadBytes = utf8.encode(jsonEncode(request.toJson()));
  return sha256.convert(payloadBytes).toString();
}
