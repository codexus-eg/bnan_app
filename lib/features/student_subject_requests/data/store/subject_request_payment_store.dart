import 'dart:convert';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payment_draft.dart';

class SubjectRequestPaymentStore {
  const SubjectRequestPaymentStore();
  static const _key = 'pending_subject_request_payment';

  Future<void> save(SubjectRequestPaymentDraft draft) =>
      CacheHelper.saveData(key: _key, value: jsonEncode(draft.toJson()));

  SubjectRequestPaymentDraft? read() {
    final raw = CacheHelper.getData(key: _key);
    if (raw is! String || raw.isEmpty) return null;
    try {
      final value = jsonDecode(raw);
      return value is Map
          ? SubjectRequestPaymentDraft.fromJson(
              Map<String, dynamic>.from(value),
            )
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => CacheHelper.removeData(key: _key);
}
