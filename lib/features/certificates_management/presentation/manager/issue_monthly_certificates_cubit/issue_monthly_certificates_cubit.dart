import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/issue_monthly_certificates_cubit/issue_monthly_certificates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssueMonthlyCertificatesCubit
    extends Cubit<IssueMonthlyCertificatesState> {
  IssueMonthlyCertificatesCubit(this.repo)
    : super(IssueMonthlyCertificatesInitial());

  final CertificatesManagementRepo repo;
  static IssueMonthlyCertificatesCubit get(context)=>BlocProvider.of(context);

  Future<void> issueMonthlyCertificates() async {
    emit(IssueMonthlyCertificatesLoading());

    final result = await repo.issueMonthlyCertificates();

    result.fold(
      (failure) => emit(IssueMonthlyCertificatesFailure(failure.message)),
      (response) => emit(IssueMonthlyCertificatesSuccess(response)),
    );
  }
}
