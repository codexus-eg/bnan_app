class UnassignSupervisorResponseModel {
  const UnassignSupervisorResponseModel({this.success = false, this.data});

  final bool success;
  final UnassignSupervisorDataModel? data;

  factory UnassignSupervisorResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UnassignSupervisorResponseModel(
      success: json['success'] == true,
      data: data is Map
          ? UnassignSupervisorDataModel.fromJson(
              Map<String, dynamic>.from(data),
            )
          : null,
    );
  }
}

class UnassignSupervisorDataModel {
  const UnassignSupervisorDataModel({
    this.supervisorId = '',
    this.classroomId = '',
    this.isActive = false,
    this.unassignedAt,
  });

  final String supervisorId;
  final String classroomId;
  final bool isActive;
  final DateTime? unassignedAt;

  factory UnassignSupervisorDataModel.fromJson(Map<String, dynamic> json) {
    return UnassignSupervisorDataModel(
      supervisorId: json['supervisor']?.toString() ?? '',
      classroomId: json['classroom']?.toString() ?? '',
      isActive: json['isActive'] == true,
      unassignedAt: DateTime.tryParse(json['unassignedAt']?.toString() ?? ''),
    );
  }
}
