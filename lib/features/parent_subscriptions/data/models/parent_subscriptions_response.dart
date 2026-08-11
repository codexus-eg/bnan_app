import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';

class ParentSubscriptionsResponse {
  const ParentSubscriptionsResponse({this.children = const []});
  final List<ParentChildSubscriptionsModel> children;

  factory ParentSubscriptionsResponse.fromJson(Map<String, dynamic> json) {
    final list = _childrenList(json);
    return ParentSubscriptionsResponse(
      children: list
          .map(
            (item) => ParentChildSubscriptionsModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .map((item) {
            if (item.studentId.isEmpty) {
              throw const FormatException('Missing child id');
            }
            return item;
          })
          .toList(growable: false),
    );
  }

  static List<dynamic> rawChildren(Map<String, dynamic> json) =>
      _childrenList(json);
}

List<dynamic> _childrenList(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is List) return data;
  if (data is Map && data['children'] is List) {
    return data['children'] as List;
  }
  if (json['children'] is List) return json['children'] as List;
  throw const FormatException('Invalid subscriptions response');
}
