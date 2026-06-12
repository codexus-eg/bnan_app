import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherNoteCard extends StatelessWidget {
  const TeacherNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            ImageManager.starOutlinedIcon,
            width: 24,
            height: 24,
    
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).teacherNote,
                  style: StylesManager.styleBold14(context).copyWith(
                    color: ColorManager.mainColor14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.of(context).teacherNoteText,
                  style: StylesManager.styleRegular12(context).copyWith(
                    color: ColorManager.greyA8AF,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}