class SubmitAssignmentResponseModel {
  final bool success;
  final String message;

  const SubmitAssignmentResponseModel({
    required this.success,
    required this.message,
  });

  factory SubmitAssignmentResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitAssignmentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'تم تسليم الواجب بنجاح',
    );
  }
}