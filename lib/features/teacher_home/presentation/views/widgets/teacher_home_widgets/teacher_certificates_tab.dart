import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificates_content.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesTab extends StatelessWidget {
  const TeacherCertificatesTab({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => TeacherCertificatesCubit(
      getIt<CertificatesManagementRepo>(),
      getIt<SupervisorIdealTeacherRepo>(),
      mine: true,
    )..load(),
    child: Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).certificates,
        iconNeeded: false,
      ),
      body: BlocBuilder<TeacherCertificatesCubit, TeacherCertificatesState>(
        builder: (_, state) => TeacherCertificatesContent(state: state),
      ),
    ),
  );
}
