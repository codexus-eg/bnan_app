import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddPackageButton extends StatelessWidget {
  const AddPackageButton({
    super.key,
    required this.curriculums,
    required this.labels,
  });

  final List<String> curriculums;
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    return AddNewTopicButton(
      title: S.of(context).addNewPackage,
      path: ImageManager.plus,
      padding: const EdgeInsetsDirectional.only(
        start: 18,
        end: 25,
        top: 8,
        bottom: 8,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => PackageFormDialog(
            curriculums: curriculums,
            labels: labels,
            isEdit: false,
          ),
        );
      },
    );
  }
}