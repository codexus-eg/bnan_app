import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, required this.onTap});

  final LessonUiModel lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 8,
            color: Color(0xff1C252C).withAlpha((255 * .05).round()),
          ),
        ],
        border: Border(
          top: BorderSide(color: ColorManager.secondaryColor),
          left: BorderSide(color: ColorManager.secondaryColor),
          bottom: BorderSide(color: ColorManager.secondaryColor),
          right: BorderSide(
            color: ColorManager.secondaryColor,
            width: 5, // السمك اللي عايزاه
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageManager.clockTenIcon,
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lesson.startTime,
                      style: StylesManager.styleRegular12(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.subjectName,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.classroomName,
                  style: StylesManager.styleRegular12(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
                if (lesson.teacherName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    lesson.teacherName!,
                    style: StylesManager.styleRegular12(
                      context,
                    ).copyWith(color: ColorManager.greyA8AF),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
