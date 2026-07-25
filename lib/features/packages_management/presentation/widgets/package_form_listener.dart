import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageFormListener {
  const PackageFormListener._();

  static void handle(
    BuildContext context,
    PackageActionsState state, {
    required VoidCallback onSuccess,
  }) {
    if (state is CreatePackageSuccess) {
      showCustomSnackBar(
        context,
        S.of(context).packageCreatedSuccessfully,
        true,
      );
      onSuccess();
    }

    if (state is UpdatePackageSuccess) {
      showCustomSnackBar(
        context,
        S.of(context).packageUpdatedSuccessfully,
        true,
      );
      onSuccess();
    }

    if (state is CreatePackageFailure) {
      showCustomSnackBar(context, state.message, false);
    }

    if (state is UpdatePackageFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}