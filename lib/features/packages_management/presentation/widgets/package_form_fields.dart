import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_body.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:flutter/material.dart';

class PackageFormFields extends StatelessWidget {
  const PackageFormFields({
    super.key,
    required this.controllers,
    required this.curriculums,
    required this.labels,
    required this.curriculumId,
    required this.packageType,
    required this.currency,
    required this.isPopular,
    required this.onCurriculumChanged,
    required this.onTypeChanged,
    required this.onCurrencyChanged,
    required this.onPopularChanged,
    required this.onSave,
  });

  final PackageFormControllers controllers;
  final List<String> curriculums;
  final Map<String, String> labels;
  final String? curriculumId;
  final String packageType;
  final String currency;
  final bool isPopular;
  final ValueChanged<String?> onCurriculumChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String?> onCurrencyChanged;
  final ValueChanged<bool> onPopularChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return PackageFormBody(
      controllers: controllers,
      curriculums: curriculums,
      labels: labels,
      curriculumId: curriculumId,
      packageType: packageType,
      currency: currency,
      isPopular: isPopular,
      onCurriculumChanged: onCurriculumChanged,
      onTypeChanged: onTypeChanged,
      onCurrencyChanged: onCurrencyChanged,
      onPopularChanged: onPopularChanged,
      onSave: onSave,
    );
  }
}