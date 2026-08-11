import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';

sealed class GetParentSubscriptionsState {
  const GetParentSubscriptionsState();
}

class GetParentSubscriptionsInitial extends GetParentSubscriptionsState {
  const GetParentSubscriptionsInitial();
}

class GetParentSubscriptionsLoading extends GetParentSubscriptionsState {
  const GetParentSubscriptionsLoading();
}

class GetParentSubscriptionsFailure extends GetParentSubscriptionsState {
  const GetParentSubscriptionsFailure(this.message);
  final String message;
}

class GetParentSubscriptionsSuccess extends GetParentSubscriptionsState {
  const GetParentSubscriptionsSuccess(this.children, {this.selectedChildId});
  final List<ParentChildSubscriptionsModel> children;
  final String? selectedChildId;
  ParentChildSubscriptionsModel? get selectedChild =>
      children.where((item) => item.studentId == selectedChildId).firstOrNull;
}
