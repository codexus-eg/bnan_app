import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lessons_widgets/lesson_card_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UpcomingLessonCard extends StatelessWidget {
  const UpcomingLessonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).upcomingLesson,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.black),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.fromSTEB(12, 14, 12, 10),
            decoration: BoxDecoration(
              color: ColorManager.greyF8F9,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withAlpha((255 * .25).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LessonCardBody(),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: S.of(context).startLessonViaZoom,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
