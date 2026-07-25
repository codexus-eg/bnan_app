import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_body.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageFormDialog extends StatefulWidget {
  const PackageFormDialog({
    super.key,
    required this.curriculums,
    required this.labels,
    required this.isEdit,
  });

  final List<String> curriculums;
  final Map<String, String> labels;
  final bool isEdit;

  @override
  State<PackageFormDialog> createState() => PackageFormDialogState();
}

class PackageFormDialogState extends State<PackageFormDialog> {
  final controllers = PackageFormControllers();
  String? curriculumId;
  String packageType = 'hours';
  bool isPopular = false;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(
              title: widget.isEdit
                  ? S.of(context).editPackage
                  : S.of(context).addNewPackage,
            ),
            const SizedBox(height: 18),
            PackageFormBody(
              controllers: controllers,
              curriculums: widget.curriculums,
              labels: widget.labels,
              curriculumId: curriculumId,
              packageType: packageType,
              isPopular: isPopular,
              onCurriculumChanged: (value) {
                setState(() => curriculumId = value);
              },
              onTypeChanged: (value) {
                setState(() => packageType = value);
              },
              onPopularChanged: (value) {
                setState(() => isPopular = value);
              },
              onSave: () {
                // Add Package
              },
            ),
          ],
        ),
      ),
    );
  }
}
