import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_layout.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/packages_management_body.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_body.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeBody extends StatelessWidget {
  const AdminHomeBody({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminHomeLayout(onMenuTap: onMenuTap),
      BlocProvider(
        create: (_) => getIt<UsersManagementCubit>()..getUsers(),
        child: const UsersManagementBody(),
      ),
      // AdminPlaceholderTab(title: s.adminSupervisors, onMenuTap: onMenuTap),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<GetSubjectsCubit>()..getSubjects()),
          BlocProvider(create: (_) => getIt<SubjectActionsCubit>()),
        ],
        child: const SubjectManagementBody(),
      ),

      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<AcademicLookupsCubit>()..loadCurriculums(),
          ),
          BlocProvider(
            create: (context) => getIt<GetPackagesCubit>()..getPackages(),
          ),
          BlocProvider(create: (context) => getIt<PackageActionsCubit>()),
        ],
        child: const PackagesManagementBody(),
      ),
    ];

    return pages[index];
  }
}
