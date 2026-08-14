import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentSubscriptionsRepo {
  Future<Either<Failure, ParentChildSubscriptionsModel>> getSubscriptions();
}
