class UpdateLoggedUserResponseModel {
  final String message;

  UpdateLoggedUserResponseModel({
    required this.message,
  });

  factory UpdateLoggedUserResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateLoggedUserResponseModel(
      message: json['message'] ?? 'تم التحديث بنجاح',
    );
  }
}