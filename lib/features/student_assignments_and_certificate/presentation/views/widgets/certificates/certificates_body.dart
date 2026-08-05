import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_failure.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_header_card.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesBody extends StatelessWidget {
  const CertificatesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetCertificatesCubit>()..getMyCertificates(),
      child: Column(
        children: [
          CustomAppbar(
            headerText: S.of(context).certificates,
            iconNeeded: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: BlocBuilder<GetCertificatesCubit, GetCertificatesState>(
                builder: (context, state) => _content(context, state),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, GetCertificatesState state) {
    if (state is GetCertificatesFailure) {
      return CertificatesFailure(
        onRetry: context.read<GetCertificatesCubit>().retry,
      );
    }
    if (state is GetCertificatesEmpty) {
      return NoDataWidget(title: S.of(context).noCertificatesAvailable);
    }
    final loading = state is GetCertificatesLoading;
    final certificates = state is GetCertificatesSuccess
        ? state.certificates
        : List.generate(2, (_) => CertificateModel.placeholder());
    return AppSkeletonizer(
      isLoading: loading,
      child: Column(
        children: [
          const CertificatesHeaderCard(),
          const SizedBox(height: 16),
          CertificatesList(certificates: certificates),
        ],
      ),
    );
  }
}
