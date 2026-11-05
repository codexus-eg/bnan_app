import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewClassScheduleButton extends StatelessWidget {
  const ViewClassScheduleButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('viewClassScheduleButton'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorManager.white.withAlpha(180),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              ImageManager.calendarIcon,
              width: 14,
              height: 14,
              colorFilter: const ColorFilter.mode(
                ColorManager.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                S.of(context).viewClassSchedule,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleRegular12(context).copyWith(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: StylesManager.fontSans,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
