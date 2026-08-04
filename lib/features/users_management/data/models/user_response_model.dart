import 'user_model.dart';

class UserResponseModel {
  const UserResponseModel({required this.success, required this.user});

  final bool success;
  final UserItem? user;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      success: json['success'] == true,
      user: _readUser(json['data'] ?? json['user']),
    );
  }
}

UserItem? _readUser(Object? data) {
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final nestedUser = map['user'];
    return UserItem.fromJson(
      nestedUser is Map ? Map<String, dynamic>.from(nestedUser) : map,
    );
  }

  if (data is List) {
    final users = data.whereType<Map>();
    return users.isEmpty
        ? null
        : UserItem.fromJson(Map<String, dynamic>.from(users.first));
  }

  return null;
}
