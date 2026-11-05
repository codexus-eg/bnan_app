import 'package:bnan_app/generated/l10n.dart';

String subjectRequestStatusLabel(S s, String? status) =>
    switch (status?.toLowerCase()) {
      'enrolled' => s.subjectStatusEnrolled,
      'pending' => s.subjectStatusPending,
      'awaiting_admin_approval' => s.subjectRequestAdminReview,
      'assigned' => s.subjectRequestAssigned,
      'rejected' => s.subjectRequestRejected,
      _ => status ?? '',
    };
