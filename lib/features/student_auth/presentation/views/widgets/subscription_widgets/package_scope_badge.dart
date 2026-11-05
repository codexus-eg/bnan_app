import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageScopeBadge extends StatelessWidget {
  const PackageScopeBadge({
    super.key,
    this.scope = PackageAccessScope.singleSubject,
  });
  final String scope;

  @override
  Widget build(BuildContext context) {
    final label = switch (scope.trim().toLowerCase()) {
      PackageAccessScope.sharedSubjects => S.of(context).sharedSubjects,
      PackageAccessScope.allSubjects => S.of(context).allSubjects,
      _ => S.of(context).singleSubject,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.mainColor14.withAlpha(24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: StylesManager.styleBold8(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
    );
  }
}
