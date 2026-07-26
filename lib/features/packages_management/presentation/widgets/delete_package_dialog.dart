import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeletePackageDialog extends StatelessWidget {
  const DeletePackageDialog({
    super.key,
    required this.packageId,
    this.curriculumId,
  });

  final String packageId;
  final String? curriculumId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackageActionsCubit, PackageActionsState>(
      listener: (context, state) {
        if (state is DeletePackageSuccess) {
          _refreshPackages(context);

          showCustomSnackBar(
            context,
            S.of(context).packageDeletedSuccessfully,
            true,
          );

          Navigator.pop(context);
        }

        if (state is DeletePackageFailure) {
          showCustomSnackBar(
            context,
            state.message,
            false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeletePackageLoading;

        return CustomDeleteDialog(
          gradeId: packageId,
          isLoading: isLoading,
          dialogHeader: S.of(context).deletePackage,
          subtitle: S.of(context).deletePackageConfirmation,
          onPressed: isLoading
              ? null
              : () {
                  context
                      .read<PackageActionsCubit>()
                      .deletePackage(packageId);
                },
        );
      },
    );
  }

  void _refreshPackages(BuildContext context) {
    final cubit = context.read<GetPackagesCubit>();

    if (curriculumId == null || curriculumId!.isEmpty) {
      cubit.getPackages();
      return;
    }

    cubit.getPackagesByCurriculum(curriculumId!);
  }
}