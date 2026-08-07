import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesContent extends StatelessWidget {
  const CertificatesContent({super.key, required this.isChildCertificates});

  final bool isChildCertificates;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCertificatesCubit, GetCertificatesState>(
      builder: (context, state) =>
          certificatesStateView(context, state, isChildCertificates),
    );
  }
}
