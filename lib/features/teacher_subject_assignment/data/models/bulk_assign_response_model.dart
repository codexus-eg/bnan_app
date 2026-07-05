class BulkAssignTeachingAssignmentsResponseModel {
  final bool success;
  final BulkAssignData data;

  BulkAssignTeachingAssignmentsResponseModel({
    required this.success,
    required this.data,
  });

  factory BulkAssignTeachingAssignmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return BulkAssignTeachingAssignmentsResponseModel(
      success: json['success'] ?? false,
      data: BulkAssignData.fromJson(json['data'] ?? {}),
    );
  }
}

class BulkAssignData {
  final int createdCount;
  final int alreadyExistsCount;
  final List<BulkAssignmentItem> assignments;

  BulkAssignData({
    required this.createdCount,
    required this.alreadyExistsCount,
    required this.assignments,
  });

  factory BulkAssignData.fromJson(Map<String, dynamic> json) {
    return BulkAssignData(
      createdCount: json['createdCount'] ?? 0,
      alreadyExistsCount: json['alreadyExistsCount'] ?? 0,
      assignments: json['assignments'] != null
          ? (json['assignments'] as List).map((i) => BulkAssignmentItem.fromJson(i)).toList()
          : [],
    );
  }
}

class BulkAssignmentItem {
  final String id;
  final String classroom;
  final String subject;

  BulkAssignmentItem({
    required this.id,
    required this.classroom,
    required this.subject,
  });

  factory BulkAssignmentItem.fromJson(Map<String, dynamic> json) {
    return BulkAssignmentItem(
      id: _asString(json['_id'] ?? json['id']),
      classroom: _asString(json['classroom']),
      subject: _asString(json['subject']),
    );
  }
}

String _asString(Object? value) => value?.toString().trim() ?? '';
