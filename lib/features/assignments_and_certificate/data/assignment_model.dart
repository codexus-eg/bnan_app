import 'package:bnan_app/features/assignments_and_certificate/data/assignment_status.dart';

class AssignmentModel {
  const AssignmentModel( {
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.badgeText,
    required this.status,
    required this.canSubmit
  });

  final String subject;
  final String title;
  final String dueDate;
  final String badgeText;
  final AssignmentStatus status;
  final bool canSubmit;
}