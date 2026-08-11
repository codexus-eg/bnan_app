import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestPackageGrid extends StatelessWidget {
  const SubjectRequestPackageGrid({
    super.key,
    required this.packages,
    this.selectedId,
  });

  final List<PackageModel> packages;
  final String? selectedId;

  @override
  Widget build(BuildContext context) => PackagesGrid(
    plans: packages
        .map(
          (item) =>
              PackageCardModel.fromPackage(context: context, package: item),
        )
        .toList(),
    packages: packages,
    curriculumId: '',
    curriculumName: '',
    bottomWidget: (_, item) => CustomAppButton(
      height: 38,
      text: selectedId == item.id
          ? S.of(context).parentPackageSelected
          : S.of(context).parentChoosePackage,
      backgroundColor: selectedId == item.id
          ? ColorManager.secondaryColor
          : ColorManager.mainColor14,
      textColor: selectedId == item.id ? ColorManager.mainColor14 : null,
      onPressed: () => Navigator.pop(context, item.id),
    ),
  );
}
