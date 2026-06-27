import 'package:bnan_app/features/student_assignments_and_certificate/data/models/assignment_status.dart';
import 'package:bnan_app/generated/l10n.dart';

class AssignmentsResponseModel {
  final bool success;
  final int results;
  final List<AssignmentModel> assignments;

  const AssignmentsResponseModel({
    required this.success,
    required this.results,
    required this.assignments,
  });

  factory AssignmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return AssignmentsResponseModel(
      success: json['success'] ?? false,
      results: json['results'] ?? 0,
      assignments: (json['data'] as List<dynamic>? ?? [])
          .map((item) => AssignmentModel.fromJson(item))
          .toList(),
    );
  }
}

class AssignmentModel {
  final String id;
  final String subject;
  final String title;
  final String dueDate;
  final String badgeText;
  final AssignmentStatus status;
  final bool canSubmit;
  final String attachment;
  final bool submitted;
  final num? grade;
  final int totalPoints;

  const AssignmentModel({
    required this.id,
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.badgeText,
    required this.status,
    required this.canSubmit,
    required this.attachment,
    required this.submitted,
    required this.grade,
    required this.totalPoints,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    final submitted = json['submitted'] ?? false;
    final grade = json['grade'];
    final totalPoints = json['totalPoints'] ?? 0;
    final isCompleted = submitted == true && grade != null && grade > 0;

    return AssignmentModel(
      id: json['id'] ?? '',
      subject: json['subjectName'] ?? '',
      title: json['title'] ?? '',
      dueDate: json['description'] ?? '',
      attachment: json['attachment'] ?? '',
      submitted: submitted,
      grade: grade,
      totalPoints: totalPoints,
      status: isCompleted
          ? AssignmentStatus.completed
          : AssignmentStatus.pending,
      canSubmit: submitted == false,
      badgeText: _getBadgeText(
        submitted: submitted,
        grade: grade,
        totalPoints: totalPoints,
      ),
    );
  }

  factory AssignmentModel.placeholder() {
    return const AssignmentModel(
      id: '',
      subject: 'الرياضيات',
      title: 'تمارين الفصل الثالث',
      dueDate: 'حتى الجمعة',
      badgeText: 'جديد',
      status: AssignmentStatus.pending,
      canSubmit: true,
      attachment: '',
      submitted: false,
      grade: null,
      totalPoints: 20,
    );
  }

  static String _getBadgeText({
    required bool submitted,
    required num? grade,
    required int totalPoints,
  }) {
    if (submitted == true && grade != null && grade >= 0) {
      return '${grade.toInt()}/$totalPoints';
    }

    if (submitted == true) {
      return S.current.submittedBadge;
    }

    return S.current.newBadge;
  }

  static List<AssignmentModel> placeholderList() {
    return List.generate(
      5,
      (_) => AssignmentModel.placeholder(),
    );
  }
}