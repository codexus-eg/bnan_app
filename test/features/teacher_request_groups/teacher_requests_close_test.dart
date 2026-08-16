import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_response_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/repo/teacher_registration_requests_repo.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'teacher_requests_test_data.dart';

void main() {
  test('refresh completion after close does not emit', () async {
    final repo = _PendingRepo();
    final cubit = TeacherRegistrationRequestsCubit(repo);
    final pending = cubit.refresh();
    await cubit.close();

    repo.result.complete(Right(page(1, 1, [request('one')])));

    await expectLater(pending, completes);
  });
}

class _PendingRepo implements TeacherRegistrationRequestsRepo {
  final result = Completer<Either<Failure, TeacherRequestsResponseModel>>();

  @override
  Future<Either<Failure, TeacherRequestsResponseModel>> getRequests({
    required int page,
    int limit = 20,
  }) => result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
