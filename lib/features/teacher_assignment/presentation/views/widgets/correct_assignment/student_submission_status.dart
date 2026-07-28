import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';

enum StudentSubmissionStatus { reviewed, submitted, notSubmitted, unknown }

extension StudentSubmissionStatusX on StudentAssignmentSubmission {
  StudentSubmissionStatus get displayStatus {
    if (!hasSubmitted || submission == null) {
      return StudentSubmissionStatus.notSubmitted;
    }

    switch (submissionStatus.toLowerCase()) {
      case 'reviewed':
        return StudentSubmissionStatus.reviewed;
      case 'submitted':
        return StudentSubmissionStatus.submitted;
      case 'not_submitted':
        return StudentSubmissionStatus.notSubmitted;
      default:
        return StudentSubmissionStatus.unknown;
    }
  }
}
