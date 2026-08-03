class UnassignTeacherResponseModel {
  const UnassignTeacherResponseModel({this.success = false, this.data});

  final bool success;
  final UnassignTeacherDataModel? data;

  factory UnassignTeacherResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UnassignTeacherResponseModel(
      success: json['success'] == true,
      data: data is Map
          ? UnassignTeacherDataModel.fromJson(Map<String, dynamic>.from(data))
          : null,
    );
  }
}

class UnassignTeacherDataModel {
  const UnassignTeacherDataModel({
    this.teacherId = '',
    this.classroomId = '',
    this.deactivatedAssignments = 0,
  });

  final String teacherId;
  final String classroomId;
  final int deactivatedAssignments;

  factory UnassignTeacherDataModel.fromJson(Map<String, dynamic> json) {
    return UnassignTeacherDataModel(
      teacherId: json['teacher']?.toString() ?? '',
      classroomId: json['classroom']?.toString() ?? '',
      deactivatedAssignments: _asInt(json['deactivatedAssignments']),
    );
  }
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
