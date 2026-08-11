import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageScopeSelector extends StatelessWidget {
  const PackageScopeSelector({
    super.key,
    required this.value,
    required this.showSingleSubject,
    required this.onChanged,
  });

  final String value;
  final bool showSingleSubject;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        S.of(context).packageAccessScope,
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
      const SizedBox(height: 8),
      CustomOptionTile(
        title: S.of(context).allSubjects,
        isSelected: value == PackageAccessScope.allSubjects,
        onTap: () => onChanged(PackageAccessScope.allSubjects),
      ),
      if (showSingleSubject)
        CustomOptionTile(
          title: S.of(context).singleSubject,
          isSelected: value == PackageAccessScope.singleSubject,
          onTap: () => onChanged(PackageAccessScope.singleSubject),
        ),
    ],
  );
}
