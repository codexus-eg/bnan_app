import 'package:bnan_app/generated/l10n.dart';

String subjectRequestStatusLabel(S s, String? status) => switch (status) {
  'awaiting_admin_approval' => s.subjectRequestAdminReview,
  'pending' => s.subjectRequestSearchingTeacher,
  'assigned' => s.subjectRequestAssigned,
  'rejected' => s.subjectRequestRejected,
  _ => status ?? '',
};
