import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCertificatesCubit extends Cubit<GetCertificatesState> {
  GetCertificatesCubit(this.repo) : super(GetCertificatesInitial());

  final StudentCertificatesRepo repo;
  String? _studentId;
  int _requestId = 0;

  Future<void> getMyCertificates({String? studentId}) async {
    final normalizedId = studentId?.trim();
    _studentId = normalizedId == null || normalizedId.isEmpty
        ? null
        : normalizedId;
    final requestId = ++_requestId;
    emit(GetCertificatesLoading());
    final result = await repo.getMyCertificates(studentId: _studentId);
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(_failureState(failure.message, failure.statusCode)),
      (items) => emit(
        items.isEmpty ? GetCertificatesEmpty() : GetCertificatesSuccess(items),
      ),
    );
  }

  GetCertificatesState _failureState(String message, int? statusCode) {
    if (statusCode == 401) return GetCertificatesUnauthorized();
    if (message.contains('STUDENT_NOT_FOUND')) {
      return GetCertificatesStudentNotFound();
    }
    return const GetCertificatesFailure();
  }

  Future<void> retry() => getMyCertificates(studentId: _studentId);
}
