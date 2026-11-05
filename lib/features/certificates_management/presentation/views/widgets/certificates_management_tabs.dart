import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificates_management_body.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificates_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CertificatesAudience { students, teachers }

class CertificatesManagementTabs extends StatefulWidget {
  const CertificatesManagementTabs({super.key});

  @override
  State<CertificatesManagementTabs> createState() => _TabsState();
}

class _TabsState extends State<CertificatesManagementTabs> {
  late CertificatesAudience selected =
      SessionManager.instance.role == UserRole.admin
          ? CertificatesAudience.teachers
          : CertificatesAudience.students;
  late final TeacherCertificatesCubit cubit = getIt<TeacherCertificatesCubit>();

  @override
  void initState() {
    super.initState();
    if (selected == CertificatesAudience.teachers) {
      cubit.load();
    }
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: cubit,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomFilterTabs<CertificatesAudience>(
            items: {
              CertificatesAudience.students: S.of(context).studentCertificates,
              CertificatesAudience.teachers: S.of(context).teacherCertificates,
            },
            selectedItem: selected,
            onChanged: _select,
          ),
        ),
        Expanded(
          child: selected == CertificatesAudience.students
              ? const CertificatesManagementBody()
              : const TeacherCertificatesBody(),
        ),
      ],
    ),
  );

  void _select(CertificatesAudience value) {
    setState(() => selected = value);
    if (value == CertificatesAudience.teachers) cubit.load();
  }
}
