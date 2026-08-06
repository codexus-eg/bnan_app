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
}

class _FakeRepo implements StudentCertificatesRepo {
  _FakeRepo(this.results);
  final List<Either<Failure, List<CertificateModel>>> results;
  int calls = 0;

  @override
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates() async {
    return results[calls++];
  }
}
