import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCertificatesCubit extends Cubit<GetCertificatesState> {
  GetCertificatesCubit(this.repo) : super(GetCertificatesInitial());

  final StudentCertificatesRepo repo;
  bool _isLoading = false;

  Future<void> getMyCertificates() async {
    if (_isLoading) return;
    _isLoading = true;
    emit(GetCertificatesLoading());
    final result = await repo.getMyCertificates();
    result.fold(
      (_) => emit(GetCertificatesFailure()),
      (items) => emit(
        items.isEmpty ? GetCertificatesEmpty() : GetCertificatesSuccess(items),
      ),
    );
    _isLoading = false;
  }

  Future<void> retry() => getMyCertificates();
}
