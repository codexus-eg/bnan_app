class SimpleResponseModel {
  const SimpleResponseModel({
    required this.success,
    required this.message,
    this.status,
  });

  final bool success;
  final String message;
  final String? status;

  factory SimpleResponseModel.fromJson(Map<String, dynamic> json) {
    return SimpleResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      status: json['status']?.toString(),
    );
  }

  bool get isError => status == 'error';
}