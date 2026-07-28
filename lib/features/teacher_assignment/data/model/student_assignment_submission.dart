class StudentAssignmentSubmission {
  final String studentId;
  final String fullName;
  final bool hasSubmitted;
  final String submissionStatus;
  final AssignmentSubmissionDetailsModel? submission;

  const StudentAssignmentSubmission({
    required this.studentId,
    required this.fullName,
    required this.hasSubmitted,
    required this.submissionStatus,
    required this.submission,
  });

  factory StudentAssignmentSubmission.fromJson(Map<String, dynamic> json) {
    final submission = json['submission'];

    return StudentAssignmentSubmission(
      studentId: json['studentId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      hasSubmitted: json['hasSubmitted'] == true,
      submissionStatus: json['submissionStatus']?.toString() ?? '',
      submission: submission is Map
          ? AssignmentSubmissionDetailsModel.fromJson(
              Map<String, dynamic>.from(submission),
            )
          : null,
    );
  }
}

class AssignmentSubmissionDetailsModel {
  final String id;
  final String? attachment;
  final String status;
  final num? score;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AssignmentSubmissionDetailsModel({
    required this.id,
    required this.attachment,
    required this.status,
    required this.score,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignmentSubmissionDetailsModel.fromJson(Map<String, dynamic> json) {
    final attachment = json['attachment']?.toString();

    return AssignmentSubmissionDetailsModel(
      id: json['id']?.toString() ?? '',
      attachment: attachment == null || attachment.isEmpty ? null : attachment,
      status: json['status']?.toString() ?? '',
      score: _asNum(json['score']),
      submittedAt: _asDate(json['submittedAt']),
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }
}

num? _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '');
}

DateTime? _asDate(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '');
}
