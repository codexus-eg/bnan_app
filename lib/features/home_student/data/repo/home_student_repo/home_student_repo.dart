import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/home_student/data/models/student_subscription_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeStudentRepo {
  Future<Either<Failure, StudentSubscriptionModel>> getStudentSubscription();
}