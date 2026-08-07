import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget? certificatesTerminalView(
  BuildContext context,
  GetCertificatesState state,
  bool isChildCertificates,
) {
  final s = S.of(context);
  final retry = context.read<GetCertificatesCubit>().retry;
  if (state is GetCertificatesStudentNotFound) {
    return CertificatesFailure(
      message: s.cannotDisplayStudentCertificates,
      onRetry: retry,
    );
  }
  if (state is GetCertificatesUnauthorized) {
    return CertificatesFailure(message: s.errorUnauthorized, onRetry: retry);
  }
  if (state is GetCertificatesFailure) {
    return CertificatesFailure(onRetry: retry);
  }
  if (state is GetCertificatesEmpty) {
    return NoDataWidget(
      title: isChildCertificates
          ? s.noCertificatesForStudent
          : s.noCertificatesAvailable,
    );
  }
  return null;
}
