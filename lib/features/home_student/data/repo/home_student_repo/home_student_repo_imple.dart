import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/home_student/data/models/student_subscription_model.dart';
import 'package:bnan_app/features/home_student/data/repo/home_student_repo/home_student_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class HomeStudentRepoImpl implements HomeStudentRepo {
  const HomeStudentRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, StudentSubscriptionModel>>
  getStudentSubscription() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.studentSubscription,
        isProtected: true,
      );

      return Right(StudentSubscriptionModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}