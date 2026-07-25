import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_state.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_fields.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_initializer.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_listener.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_state.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_submitter.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_validation_message.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageFormDialog extends StatefulWidget {
  const PackageFormDialog({
    super.key,
    required this.curriculums,
    required this.labels,
    this.package,
    required this.onSuccess,
  });

  final List<String> curriculums;
  final Map<String, String> labels;
  final PackageModel? package;
  final VoidCallback onSuccess;

  bool get isEdit => package != null;

  @override
  State<PackageFormDialog> createState() => PackageFormDialogState();
}

class PackageFormDialogState extends State<PackageFormDialog> {
  final controllers = PackageFormControllers();
  final formState = PackageFormState();

  @override
  void initState() {
    super.initState();
    final package = widget.package;
    if (package == null) return;

    PackageFormInitializer.fillControllers(
      controllers: controllers,
      package: package,
    );

    formState.curriculumId = package.curriculum;
    formState.packageType = package.type ?? 'hours';
    formState.currency = package.currency ?? 'SAR';
    formState.isPopular = package.isPopular ?? false;
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackageActionsCubit, PackageActionsState>(
      listener: (context, state) {
        PackageFormListener.handle(
          context,
          state,
          onSuccess: () {
            Navigator.pop(context);
            widget.onSuccess();
          },
        );
      },
      builder: (context, state) {
        final isLoading =
            state is CreatePackageLoading || state is UpdatePackageLoading;

        return CustomAppDialog(
          
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomDialogHeader(
                  title: widget.isEdit
                      ? S.of(context).editPackage
                      : S.of(context).addNewPackage,
                ),
                const SizedBox(height: 18),
                _fields(isLoading),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fields(bool isLoading) {
    return PackageFormFields(
      controllers: controllers,
      curriculums: widget.curriculums,
      labels: widget.labels,
      curriculumId: formState.curriculumId,
      packageType: formState.packageType,
      currency: formState.currency,
      isPopular: formState.isPopular,
      onCurriculumChanged: (value) =>
          setState(() => formState.curriculumId = value),
      onTypeChanged: (value) => setState(() => formState.packageType = value),
      onCurrencyChanged: (value) {
        if (value != null) {
          setState(() => formState.currency = value);
        }
      },
      onPopularChanged: (value) => setState(() => formState.isPopular = value),
      onSave: isLoading ? () {} : _submit,
    );
  }

  void _submit() {
    final error = PackageFormSubmitter.submit(
      cubit: context.read<PackageActionsCubit>(),
      controllers: controllers,
      formState: formState,
      package: widget.package,
    );

    if (error == null) return;

    showCustomSnackBar(
      context,
      PackageFormValidationMessage.fromKey(context, error),
      false,
    );
  }
}
