import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_header_card.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_list.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_terminal_view.dart';
import 'package:flutter/material.dart';

Widget certificatesStateView(
  BuildContext context,
  GetCertificatesState state,
  bool isChildCertificates,
) {
  final terminal = certificatesTerminalView(
    context,
    state,
    isChildCertificates,
  );
  if (terminal != null) return terminal;
  final items = state is GetCertificatesSuccess
      ? state.certificates
      : List.generate(2, (_) => CertificateModel.placeholder());
  return AppSkeletonizer(
    isLoading: state is! GetCertificatesSuccess,
    child: Column(
      children: [
        const CertificatesHeaderCard(),
        const SizedBox(height: 16),
        CertificatesList(certificates: items),
      ],
    ),
  );
}
