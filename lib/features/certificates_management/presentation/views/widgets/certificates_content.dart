import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_summary_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/monthly_certificates_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesContent extends StatelessWidget {
  const CertificatesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetMonthlyCertificatesCubit,
      GetMonthlyCertificatesState
    >(
      builder: (context, state) {
        if (state is GetMonthlyCertificatesFailure) {
          return NoDataWidget(
            
          );
        }

        if (state is GetMonthlyCertificatesSuccess &&
            state.response.data.isEmpty) {
          return const NoDataWidget();
        }

        final certificates = state is GetMonthlyCertificatesSuccess
            ? state.response.data
            : MonthlyCertificateSummaryModel.placeholderCertificates;

        return AppSkeletonizer(
          isLoading: state is GetMonthlyCertificatesLoading,
          child: MonthlyCertificatesList(
            certificates: certificates,
          ),
        );
      },
    );
  }
}