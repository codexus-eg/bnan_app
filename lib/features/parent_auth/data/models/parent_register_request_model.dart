class ParentRegisterRequestModel {
  const ParentRegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.whatsappNumber,
  });

  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String whatsappNumber;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'phone': phone.trim(),
      'whatsappNumber': whatsappNumber.trim(),
    };
  }
}
