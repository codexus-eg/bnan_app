import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LessonsSelectedDateHeader extends StatelessWidget {
  const LessonsSelectedDateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 9,end: 9,top: 16,bottom: 
       10),
        decoration: const BoxDecoration(
          color: ColorManager.mainColor14,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.secondaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              S.of(context).selectedLessonDatePreview,
              style: StylesManager.styleMedium14(
                context,
              ).copyWith(color: ColorManager.greyECE),
            ),
            Spacer(),
            SvgPicture.asset(
              ImageManager.parentCalendarIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                ColorManager.greyA8AF,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
