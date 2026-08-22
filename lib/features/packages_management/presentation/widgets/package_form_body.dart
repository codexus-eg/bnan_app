import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_content.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_popular_switch.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_scope_selector.dart';
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
    required this.accessScope,
    required this.canSelectSingleSubject,
    required this.showMonthly,
    required this.isPopular,
    required this.onCurriculumChanged,
    required this.onTypeChanged,
    required this.onScopeChanged,
    required this.onPopularChanged,
    required this.onSave,
    required this.isLoading,
    required this.currency,
    required this.onCurrencyChanged,
    this.errorMessage,
  });

  final PackageFormControllers controllers;
  final List<String> curriculums;
  final Map<String, String> labels;
  final String? curriculumId;
  final String packageType;
  final String accessScope;
  final bool canSelectSingleSubject;
  final bool showMonthly;
  final bool isPopular;
  final ValueChanged<String?> onCurriculumChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onScopeChanged;
  final ValueChanged<bool> onPopularChanged;
  final VoidCallback? onSave;
  final bool isLoading;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDropdown(
          hint: S.of(context).chooseNewCurriculum,
          label: S.of(context).curriculum,
          value: curriculumId,
          items: curriculums,
          itemsLabels: labels,
          isRequired: true,
          onChanged: onCurriculumChanged,
        ),
        const SizedBox(height: 16),
        PackageScopeSelector(
          value: accessScope,
          showSingleSubject: canSelectSingleSubject,
          onChanged: onScopeChanged,
        ),
        const SizedBox(height: 16),
        PackageTypeSelector(
          value: packageType,
          onChanged: onTypeChanged,
          showMonthly: showMonthly,
          monthlyEnabled: accessScope != 'single_subject',
          hoursEnabled:
              !canSelectSingleSubject || accessScope == 'single_subject',
        ),
        const SizedBox(height: 16),
        PackageFormContent(
          controllers: controllers,
          currency: currency,
          onCurrencyChanged: onCurrencyChanged,
          isSingleSubject: accessScope == 'single_subject',
          showDuration:
              !canSelectSingleSubject || accessScope == 'single_subject',
        ),
        const SizedBox(height: 16),
        PackagePopularSwitch(value: isPopular, onChanged: onPopularChanged),
        const SizedBox(height: 16),
        if (errorMessage != null) ...[
          Center(
            child: Text(
              errorMessage!,
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8),
        ],
        CustomAppButton(
          text: S.of(context).save,
          height: 44,
          isLoading: isLoading,
          onPressed: onSave,
        ),
      ],
    ),
  );
}
