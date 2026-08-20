import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/certificates_management_view.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_tab_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorCertificatesTab extends StatelessWidget {
  const SupervisorCertificatesTab({this.refreshKey, super.key});

  final GlobalKey<SupervisorTabRefreshState>? refreshKey;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<DeleteMonthlyCertificateCubit>()),
      BlocProvider(create: (_) => getIt<GetMonthlyCertificatesCubit>()),
      BlocProvider(create: (_) => getIt<GetSupervisorClassroomsCubit>()),
      BlocProvider(create: (_) => getIt<GetCertificateDetailsCubit>()),
      BlocProvider(create: (_) => getIt<IssueMonthlyCertificatesCubit>()),
      BlocProvider(create: (_) => getIt<UpdateMonthlyCertificateCubit>()),
      BlocProvider(create: (_) => getIt<CreateMonthlyCertificateCubit>()),
    ],
    child: SupervisorTabRefresh(
      key: refreshKey,
      route: Routes.certificatesManagement,
      child: const CertificatesManagementView(showBackButton: false),
    ),
  );
}
