class UpdateProfileResponseModel {
  final bool success;
  final UpdateProfileDataModel data;
  final String message;

  const UpdateProfileResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      success: json['success'] ?? false,
      data: UpdateProfileDataModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? 'تم التحديث بنجاح',
    );
  }
}

class UpdateProfileDataModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? status;
  final String? phone;
  final String? whatsappNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? passwordChangedAt;

  const UpdateProfileDataModel({
    required this.id,
    this.fullName,
    this.email,
    this.role,
    this.status,
    this.phone,
    this.whatsappNumber,
    this.createdAt,
    this.updatedAt,
    this.passwordChangedAt,
  });

  factory UpdateProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileDataModel(
      id: json['id'] ?? '',
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      phone: json['phone'],
      whatsappNumber: json['whatsappNumber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      passwordChangedAt: json['passwordChangedAt'],
    );
  }
}