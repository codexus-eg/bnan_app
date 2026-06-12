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
    required this.isDaysPackage,
  });

  final int remainingHours;
  final int usedHours;
  final int totalHours;
  final bool isDaysPackage;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isDaysPackage
              ? s.daysPackage(totalHours)
              : s.hoursPackage(totalHours),
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              isDaysPackage
                  ? s.usedDays(usedHours, totalHours)
                  : s.usedHours(usedHours, totalHours),
              style: StylesManager.styleRegular12(context).copyWith(
                color: ColorManager.white,
              ),
            ),
            const Spacer(),
            Text(
              isDaysPackage
                  ? s.remainingDays(remainingHours)
                  : s.remainingHours(remainingHours),
              style: StylesManager.styleBold12(context).copyWith(
                color: ColorManager.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}