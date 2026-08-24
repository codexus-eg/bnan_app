import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.token,
    required this.user,
    this.refreshToken = '',
    this.registrationRequestId = '',
    this.registrationStatus = '',
    this.paymentStatus = '',
    this.paymentId = '',
    this.paymentItems = const [],
    this.subscriptions = const [],
  });

  final bool success;
  final String token;
  final String refreshToken;
  final AuthUserModel user;
  final String registrationRequestId;
  final String registrationStatus;
  final String paymentStatus;
  final String paymentId;
  final List<Map<String, dynamic>> paymentItems;
  final List<ParentChildSubscriptionModel> subscriptions;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    final dataJson = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final responseJson = <String, dynamic>{...json, ...dataJson};
    final nestedUser = dataJson['user'];
    final userJson = <String, dynamic>{
      ...json,
      ...dataJson,
      if (nestedUser is Map<String, dynamic>) ...nestedUser,
    };

    return AuthResponseModel(
      success: json['success'] == true,
      token: (json['token'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
      user: AuthUserModel.fromJson(userJson),
      registrationRequestId: _text(responseJson['registrationRequestId']),
      registrationStatus: _text(responseJson['registrationStatus']),
      paymentStatus: _text(responseJson['paymentStatus']),
      paymentId: _text(responseJson['paymentId']),
      paymentItems: _maps(responseJson['paymentItems']),
      subscriptions: _subscriptions(responseJson['subscriptions']),
    );
  }

  bool get hasToken => token.isNotEmpty;
}

String _text(dynamic value) => value?.toString().trim() ?? '';

List<Map<String, dynamic>> _maps(dynamic value) => value is List
    ? List.unmodifiable(
        value.whereType<Map>().map(
          (item) => Map<String, dynamic>.unmodifiable(item),
        ),
      )
    : const [];

List<ParentChildSubscriptionModel> _subscriptions(dynamic value) =>
    value is List
    ? List.unmodifiable(
        value.whereType<Map>().map(
          (item) => ParentChildSubscriptionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ),
      )
    : const [];
