import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonsSelectedDayHeader extends StatelessWidget {
  const LessonsSelectedDayHeader({super.key, required this.dayLabel});

  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(9, 16, 9, 10),
        decoration: const BoxDecoration(
          color: ColorManager.mainColor14,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.secondaryColor,
              ),
              child: SizedBox.square(dimension: 8),
            ),
            const SizedBox(width: 4),
            Text(
              S.of(context).scheduleForDay(dayLabel),
              style: StylesManager.styleMedium14(
                context,
              ).copyWith(color: ColorManager.greyECE),
            ),
          ],
        ),
      ),
    );
  }
}
