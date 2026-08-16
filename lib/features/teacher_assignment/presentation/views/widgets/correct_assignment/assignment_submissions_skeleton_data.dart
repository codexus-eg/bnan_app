import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';

const skeletonTotalStudents = 3;
const skeletonReviewed = 1;
const skeletonSubmitted = 1;
const skeletonNotSubmitted = 1;

const skeletonAssignmentSubmissions = [
  StudentAssignmentSubmission(
    studentId: 'skeleton-reviewed',
    fullName: 'Student Name',
    hasSubmitted: true,
    submissionStatus: 'reviewed',
    submission: AssignmentSubmissionDetailsModel(
      id: 'skeleton-submission-reviewed',
      attachment: 'attachment.pdf',
      attachmentName: 'attachment.pdf',
      status: 'reviewed',
      score: 10,
      submittedAt: null,
      createdAt: null,
      updatedAt: null,
    ),
  ),
  StudentAssignmentSubmission(
    studentId: 'skeleton-submitted',
    fullName: 'Student Name',
    hasSubmitted: true,
    submissionStatus: 'submitted',
    submission: AssignmentSubmissionDetailsModel(
      id: 'skeleton-submission-pending',
      attachment: 'attachment.pdf',
      attachmentName: 'attachment.pdf',
      status: 'submitted',
      score: null,
      submittedAt: null,
      createdAt: null,
      updatedAt: null,
    ),
  ),
  StudentAssignmentSubmission(
    studentId: 'skeleton-not-submitted',
    fullName: 'Student Name',
    hasSubmitted: false,
    submissionStatus: 'not_submitted',
    submission: null,
  ),
];
