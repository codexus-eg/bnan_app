import 'dart:convert';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';

class PaymentDraftStore {
  const PaymentDraftStore();

  static const _key = 'pending_tamara_payment';

  Future<void> save(PaymentDraft draft) {
    return CacheHelper.saveData(key: _key, value: jsonEncode(draft.toJson()));
  }

  PaymentDraft? read() {
    final raw = CacheHelper.getData(key: _key);
    if (raw is! String || raw.trim().isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      return json is Map
          ? PaymentDraft.fromJson(Map<String, dynamic>.from(json))
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await CacheHelper.removeData(key: _key);
  }
}
