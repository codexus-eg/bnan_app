import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/certificates_management_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesTab extends StatelessWidget {
  const TeacherCertificatesTab({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<DeleteMonthlyCertificateCubit>()),
      BlocProvider(
        create: (_) =>
            getIt<GetMonthlyCertificatesCubit>()..getMonthlyCertificates(),
      ),
      BlocProvider(
        create: (_) =>
            getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
      ),
      BlocProvider(create: (_) => getIt<GetCertificateDetailsCubit>()),
      BlocProvider(create: (_) => getIt<IssueMonthlyCertificatesCubit>()),
      BlocProvider(create: (_) => getIt<UpdateMonthlyCertificateCubit>()),
      BlocProvider(create: (_) => getIt<CreateMonthlyCertificateCubit>()),
    ],
    child: const CertificatesManagementView(showBackButton: false),
  );
}
