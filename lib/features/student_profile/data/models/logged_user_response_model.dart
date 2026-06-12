import 'logged_user_model.dart';

class LoggedUserResponseModel {
  final bool success;
  final LoggedUserModel loggedUser;

  const LoggedUserResponseModel({
    required this.success,
    required this.loggedUser,
  });

  factory LoggedUserResponseModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserResponseModel(
      success: json['success'] ?? false,
      loggedUser: LoggedUserModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': loggedUser.toJson(),
    };
  }
}