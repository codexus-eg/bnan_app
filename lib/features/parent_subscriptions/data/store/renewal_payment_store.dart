import 'dart:convert';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_payment_draft.dart';

class RenewalPaymentStore {
  const RenewalPaymentStore();
  static const _key = 'pending_subscription_renewal_payment';

  Future<void> save(RenewalPaymentDraft draft) =>
      CacheHelper.saveData(key: _key, value: jsonEncode(draft.toJson()));

  RenewalPaymentDraft? read() {
    final raw = CacheHelper.getData(key: _key);
    if (raw is! String || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      return json is Map
          ? RenewalPaymentDraft.fromJson(Map<String, dynamic>.from(json))
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => CacheHelper.removeData(key: _key);
}
