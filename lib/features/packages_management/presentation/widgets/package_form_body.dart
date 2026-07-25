import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_content.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_popular_switch.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_type_selector.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageFormBody extends StatelessWidget {
  const PackageFormBody({
    super.key,
    required this.controllers,
    required this.curriculums,
    required this.labels,
    required this.curriculumId,
    required this.packageType,
    required this.isPopular,
    required this.onCurriculumChanged,
    required this.onTypeChanged,
    required this.onPopularChanged,
    required this.onSave,
  });

  final PackageFormControllers controllers;
  final List<String> curriculums;
  final Map<String, String> labels;
  final String? curriculumId;
  final String packageType;
  final bool isPopular;
  final ValueChanged<String?> onCurriculumChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<bool> onPopularChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          CustomDropdown(
            label: S.of(context).curriculum,
            value: curriculumId,
            items: curriculums,
            itemsLabels: labels,
            isRequired: true,
            onChanged: onCurriculumChanged,
          ),
          const SizedBox(height: 16),
          PackageTypeSelector(value: packageType, onChanged: onTypeChanged),
          const SizedBox(height: 16),
          PackageFormContent(controllers: controllers),
          const SizedBox(height: 16),
          PackagePopularSwitch(value: isPopular, onChanged: onPopularChanged),
          const SizedBox(height: 16),
          CustomAppButton(text: S.of(context).save, height: 44, onPressed: onSave),
        ],
      ),
    ),
  );
}