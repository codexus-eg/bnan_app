import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits loading then success, empty, failure, and retries', () async {
    final repo = _FakeRepo([
      Right([CertificateModel.placeholder()]),
      const Right([]),
      Left(Failure(message: 'server')),
    ]);
    final cubit = GetCertificatesCubit(repo);

    await cubit.getMyCertificates();
    expect(cubit.state, isA<GetCertificatesSuccess>());
    await cubit.retry();
    expect(cubit.state, isA<GetCertificatesEmpty>());
    await cubit.retry();
    expect(cubit.state, isA<GetCertificatesFailure>());
    expect(repo.calls, 3);
    await cubit.close();
  });

  test('maps STUDENT_NOT_FOUND and unauthorized failures', () async {
    final repo = _FakeRepo([
      Left(Failure(message: 'STUDENT_NOT_FOUND', statusCode: 404)),
      Left(Failure(message: 'unauthorized', statusCode: 401)),
    ]);
    final cubit = GetCertificatesCubit(repo);

    await cubit.getMyCertificates(studentId: 'child-1');
    expect(cubit.state, isA<GetCertificatesStudentNotFound>());
    await cubit.retry();
    expect(cubit.state, isA<GetCertificatesUnauthorized>());
    expect(repo.studentIds, ['child-1', 'child-1']);
    await cubit.close();
  });

  test('ignores a previous child response after selection changes', () async {
    final first = Completer<Either<Failure, List<CertificateModel>>>();
    final second = Completer<Either<Failure, List<CertificateModel>>>();
    final repo = _CompleterRepo([first, second]);
    final cubit = GetCertificatesCubit(repo);

    final firstRequest = cubit.getMyCertificates(studentId: 'child-1');
    final secondRequest = cubit.getMyCertificates(studentId: 'child-2');
    second.complete(Right([CertificateModel.placeholder()]));
    await secondRequest;
    first.complete(const Right([]));
    await firstRequest;

    expect(cubit.state, isA<GetCertificatesSuccess>());
    expect(repo.studentIds, ['child-1', 'child-2']);
    await cubit.close();
  });
}

class _FakeRepo implements StudentCertificatesRepo {
  _FakeRepo(this.results);
  final List<Either<Failure, List<CertificateModel>>> results;
  int calls = 0;
  final List<String?> studentIds = [];

  @override
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates({
    String? studentId,
  }) async {
    studentIds.add(studentId);
    return results[calls++];
  }
}

class _CompleterRepo implements StudentCertificatesRepo {
  _CompleterRepo(this.results);

  final List<Completer<Either<Failure, List<CertificateModel>>>> results;
  final List<String?> studentIds = [];
  int calls = 0;

  @override
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates({
    String? studentId,
  }) {
    studentIds.add(studentId);
    return results[calls++].future;
  }
}
