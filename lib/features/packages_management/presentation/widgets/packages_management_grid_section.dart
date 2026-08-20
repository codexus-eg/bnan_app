import 'package:bnan_app/core/app_routes/routes_export.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/mappers/admin_package_card_mapper.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/delete_package_dialog.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_admin_actions.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:flutter/material.dart';

class PackagesManagementGridSection extends StatelessWidget {
  const PackagesManagementGridSection({
    super.key,
    required this.curriculumId,
    required this.curriculumName,
  });

  final String curriculumId;
  final String curriculumName;

  @override
  Widget build(BuildContext context) {
    final registrationModes = {
      for (final item in context.read<AcademicLookupsCubit>().state.curriculums)
        item.id.toString(): item.registrationMode,
    };
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: SubscriptionGrid(
        curriculumId: curriculumId,
        curriculumName: curriculumName,
        isSliver: false,
        planMapper: (context, package) => AdminPackageCardMapper.fromPackage(
          context,
          package,
          hidePrices:
              registrationModes[package.curriculum]?.trim().toLowerCase() ==
              'egyptian',
        ),
        bottomWidget: (plan, package) {
          return PackageAdminActions(
            plan: plan,
            onDelete: () => _showDeleteDialog(context, plan.id),
            onEdit: () => _showEditDialog(context, package),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String packageId) {
    final actionsCubit = context.read<PackageActionsCubit>();
    final packagesCubit = context.read<GetPackagesCubit>();

    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: actionsCubit),
          BlocProvider.value(value: packagesCubit),
        ],
        child: Dialog(
          child: DeletePackageDialog(
            packageId: packageId,
            curriculumId: curriculumId.isEmpty ? null : curriculumId,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, PackageModel package) {
    final lookups = context.read<AcademicLookupsCubit>();
    final actionsCubit = context.read<PackageActionsCubit>();

    final curriculums = lookups.state.curriculums
        .map((e) => e.id.toString())
        .toList();

    final labels = {
      for (final item in lookups.state.curriculums)
        item.id.toString(): item.name,
    };
    final registrationModes = {
      for (final item in lookups.state.curriculums)
        item.id.toString(): item.registrationMode,
    };

    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: actionsCubit),
          BlocProvider(create: (_) => getIt<PackageFormCubit>()),
        ],
        child: PackageFormDialog(
          curriculums: curriculums,
          labels: labels,
          registrationModes: registrationModes,
          package: package,
          onSuccess: () => _refreshPackages(context),
        ),
      ),
    );
  }

  void _refreshPackages(BuildContext context) {
    final cubit = context.read<GetPackagesCubit>();

    if (curriculumId.isEmpty) {
      cubit.getPackages();
      return;
    }

    cubit.getPackagesByCurriculum(curriculumId);
  }
}
