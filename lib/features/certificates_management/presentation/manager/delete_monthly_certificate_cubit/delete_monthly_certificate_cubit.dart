import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/delete_monthly_certificate_cubit/delete_monthly_certificate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteMonthlyCertificateCubit
    extends Cubit<DeleteMonthlyCertificateState> {
  DeleteMonthlyCertificateCubit(this.repo)
    : super(DeleteMonthlyCertificateInitial());

  final CertificatesManagementRepo repo;
  static DeleteMonthlyCertificateCubit get(context)=>BlocProvider.of(context);

  Future<void> deleteMonthlyCertificate({required String certificateId}) async {
    emit(DeleteMonthlyCertificateLoading());

    final result = await repo.deleteMonthlyCertificate(
      certificateId: certificateId,
    );

    result.fold(
      (failure) => emit(DeleteMonthlyCertificateFailure(failure.message)),
      (_) => emit(DeleteMonthlyCertificateSuccess()),
    );
  }
}
