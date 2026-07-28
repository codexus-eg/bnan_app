import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';

class AssignmentSubmissionsResponseModel {
  final bool success;
  final int results;
  final AssignmentSubmissionsAssignmentModel assignment;
  final AssignmentSubmissionsSummaryModel summary;
  final List<StudentAssignmentSubmission> data;

  const AssignmentSubmissionsResponseModel({
    required this.success,
    required this.results,
    required this.assignment,
    required this.summary,
    required this.data,
  });

  factory AssignmentSubmissionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return AssignmentSubmissionsResponseModel(
      success: json['success'] == true,
      results: _asInt(json['results']),
      assignment: AssignmentSubmissionsAssignmentModel.fromJson(
        _asMap(json['assignment']),
      ),
      summary: AssignmentSubmissionsSummaryModel.fromJson(
        _asMap(json['summary']),
      ),
      data: data is List
          ? data
                .whereType<Map>()
                .map(
                  (item) => StudentAssignmentSubmission.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class AssignmentSubmissionsAssignmentModel {
  final String id;
  final String title;

  const AssignmentSubmissionsAssignmentModel({
    required this.id,
    required this.title,
  });

  factory AssignmentSubmissionsAssignmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentSubmissionsAssignmentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class AssignmentSubmissionsSummaryModel {
  final int totalStudents;
  final int reviewed;
  final int submitted;
  final int notSubmitted;

  const AssignmentSubmissionsSummaryModel({
    required this.totalStudents,
    required this.reviewed,
    required this.submitted,
    required this.notSubmitted,
  });

  factory AssignmentSubmissionsSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentSubmissionsSummaryModel(
      totalStudents: _asInt(json['totalStudents']),
      reviewed: _asInt(json['reviewed']),
      submitted: _asInt(json['submitted']),
      notSubmitted: _asInt(json['notSubmitted']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : {};
}

int _asInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
