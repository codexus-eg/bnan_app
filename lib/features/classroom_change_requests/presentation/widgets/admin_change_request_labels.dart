import 'package:bnan_app/generated/l10n.dart';

String changeRequestStatusLabel(S s, String value) => switch (value) {
  'pending' || 'awaiting_admin_approval' => s.changeRequestPending,
  'approved' => s.changeRequestApproved,
  'rejected' => s.changeRequestRejected,
  _ => value.isEmpty ? '-' : value,
};

String changeRequestTypeLabel(S s, String value) => switch (value) {
  'change_teacher' => s.changeTeacherRequestType,
  'cancel_subject' => s.cancelSubjectRequestType,
  'teacher_request' || 'teacher_withdrawal' => s.teacherWithdrawalRequestType,
  _ => value.isEmpty ? '-' : value,
};

String changeRequesterTypeLabel(S s, String value) => switch (value) {
  'student' => s.student,
  'teacher' => s.teacher,
  _ => value.isEmpty ? '-' : value,
};
