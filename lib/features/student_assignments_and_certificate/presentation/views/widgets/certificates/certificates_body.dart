import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_content.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/parent_certificates_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesBody extends StatelessWidget {
  const CertificatesBody({
    super.key,
    this.isParent = false,
    this.showBackButton = false,
  });

  final bool isParent;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<GetCertificatesCubit>();
        if (!isParent) cubit.getMyCertificates();
        return cubit;
      },
      child: Column(
        children: [
          CustomAppbar(
            headerText: S.of(context).certificates,
            iconNeeded: showBackButton,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: isParent
                  ? const ParentCertificatesContent()
                  : const CertificatesContent(isChildCertificates: false),
            ),
          ),
        ],
      ),
    );
  }
}
