import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestPackageSelector extends StatelessWidget {
  const SubjectRequestPackageSelector({
    super.key,
    required this.hasPackages,
    required this.enabled,
    required this.onTap,
    this.selectedName,
  });

  final bool hasPackages;
  final bool enabled;
  final VoidCallback onTap;
  final String? selectedName;

  @override
  Widget build(BuildContext context) {
    final name = selectedName?.trim();
    final hasSelection = name != null && name.isNotEmpty;
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : .55,
        child: CustomTextField(
          label: S.of(context).packages,
          hintText: !enabled
              ? S.of(context).subjectRequestChooseSubject
              : hasSelection
              ? name
              : hasPackages
              ? S.of(context).subjectRequestChoosePackage
              : S.of(context).subjectRequestNoPackages,
          hintStyle: hasSelection
              ? StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.mainColor14)
              : null,
          readOnly: true,
          onTap: onTap,
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}
