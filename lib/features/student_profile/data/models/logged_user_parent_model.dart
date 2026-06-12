class LoggedUserParentModel {
  final String id;
  final String phone;

  const LoggedUserParentModel({
    required this.id,
    required this.phone,
  });

  factory LoggedUserParentModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserParentModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
    };
  }
}