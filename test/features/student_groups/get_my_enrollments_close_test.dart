import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/data/repo/student_groups_repo/student_groups_repo.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('request completion after close does not emit', () async {
    final repo = _PendingRepo();
    final cubit = GetMyEnrollmentsCubit(repo);
    final request = cubit.getMyEnrollments();
    await cubit.close();

    repo.result.complete(
      const Right(StudentEnrollmentsResponseModel(enrollments: [])),
    );

    await expectLater(request, completes);
  });
}

class _PendingRepo implements StudentGroupsRepo {
  final result = Completer<Either<Failure, StudentEnrollmentsResponseModel>>();

  @override
  Future<Either<Failure, StudentEnrollmentsResponseModel>> getMyEnrollments() =>
      result.future;
}
