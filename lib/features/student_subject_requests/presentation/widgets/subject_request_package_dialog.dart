import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_package_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestPackageDialog extends StatelessWidget {
  const SubjectRequestPackageDialog({
    super.key,
    required this.packages,
    this.selectedId,
  });

  final List<PackageModel> packages;
  final String? selectedId;

  static Future<String?> show(
    BuildContext context, {
    required List<PackageModel> packages,
    String? selectedId,
  }) => showDialog<String>(
    context: context,
    builder: (_) =>
        SubjectRequestPackageDialog(packages: packages, selectedId: selectedId),
  );

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    width: 600,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: S.of(context).packages),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .7,
            ),
            child: packages.isEmpty
                ? SizedBox(
                    height: 220,
                    child: NoDataWidget(
                      title: S.of(context).subjectRequestNoPackages,
                    ),
                  )
                : SingleChildScrollView(
                    child: SubjectRequestPackageGrid(
                      packages: packages,
                      selectedId: selectedId,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
