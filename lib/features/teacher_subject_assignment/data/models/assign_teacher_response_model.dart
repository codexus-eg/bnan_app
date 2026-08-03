class AssignTeacherResponseModel {
  const AssignTeacherResponseModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory AssignTeacherResponseModel.fromJson(Map<String, dynamic> json) {
    return AssignTeacherResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
    );
  }
}
