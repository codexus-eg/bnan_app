import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/next_lesson_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NextLessonsBody extends StatelessWidget {
  const NextLessonsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).upcomingLesson,
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: ColorManager.black),
          ),
          const SizedBox(height: 8),
          NextLessonWidget(
            widgetSession: StatusBadge(text: S.of(context).start),
          ),
          const SizedBox(height: 8),
          NextLessonWidget(
            widgetSession: SvgPicture.asset(ImageManager.clockTenIcon),
          ),
        ],
      ),
    );
  }
}
