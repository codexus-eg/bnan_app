import 'package:bnan_app/features/auth/data/models/auth_user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.token,
    required this.user,
  });

  final bool success;
  final String token;
  final AuthUserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    final userJson = data is Map<String, dynamic> &&
            data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : data is Map<String, dynamic>
            ? data
            : <String, dynamic>{};

    return AuthResponseModel(
      success: json['success'] == true,
      token: (json['token'] ?? '').toString(),
      user: AuthUserModel.fromJson(userJson),
    );
  }

  bool get hasToken => token.isNotEmpty;
}