import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo.dart';
import 'package:dartz/dartz.dart';

class StudentSubjectsRepoImpl implements StudentSubjectsRepo {
  const StudentSubjectsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, List<StudentSubjectModel>>> getMySubjects() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.mySubjects,
        isProtected: true,
      );
      return StudentSubjectModel.listFromResponse(response);
    });
  }
}
