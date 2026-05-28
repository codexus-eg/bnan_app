import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProgressInfo extends StatelessWidget {
  const ProgressInfo({
    super.key,
    required this.remainingHours,
    required this.usedHours,
    required this.totalHours,
  });

  final int remainingHours;
  final int usedHours;
  final int totalHours;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).hoursPackage(totalHours),
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: ColorManager.white),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              S.of(context).usedHours(usedHours, totalHours),
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: ColorManager.white),
            ),
            const Spacer(),

            Text(
              S.of(context).remainingHours(remainingHours),
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
      ],
    );
  }
}
