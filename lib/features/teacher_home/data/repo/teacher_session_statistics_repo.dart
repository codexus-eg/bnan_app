import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherSessionStatisticsRepo {
  Future<Either<Failure, TeacherSessionStatisticsModel>> getSessionStatistics({
    String? from,
    String? to,
  });
}
