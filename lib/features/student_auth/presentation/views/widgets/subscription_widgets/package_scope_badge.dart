import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageScopeBadge extends StatelessWidget {
  const PackageScopeBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: ColorManager.mainColor14.withAlpha(24),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      S.of(context).singleSubject,
      style: StylesManager.styleBold8(
        context,
      ).copyWith(color: ColorManager.mainColor14),
    ),
  );
}
