import 'package:bnan_app/features/home_student/data/models/student_subscription_model.dart';

sealed class GetStudentSubscriptionState {}

final class GetStudentSubscriptionInitial extends GetStudentSubscriptionState {}

final class GetStudentSubscriptionLoading extends GetStudentSubscriptionState {}

final class GetStudentSubscriptionSuccess extends GetStudentSubscriptionState {
  final StudentSubscriptionModel subscription;

  GetStudentSubscriptionSuccess({required this.subscription});
}

final class GetStudentSubscriptionFailure extends GetStudentSubscriptionState {
  final String errorMessage;

  GetStudentSubscriptionFailure({required this.errorMessage});
}