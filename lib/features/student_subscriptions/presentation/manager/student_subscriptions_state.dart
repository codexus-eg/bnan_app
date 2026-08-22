import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';

sealed class StudentSubscriptionsState {
  const StudentSubscriptionsState();
}

class StudentSubscriptionsLoading extends StudentSubscriptionsState {
  const StudentSubscriptionsLoading();
}

class StudentSubscriptionsFailure extends StudentSubscriptionsState {
  const StudentSubscriptionsFailure(this.message);
  final String message;
}

class StudentSubscriptionsSuccess extends StudentSubscriptionsState {
  const StudentSubscriptionsSuccess(this.student);
  final ParentChildSubscriptionsModel student;
}
