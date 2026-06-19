import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/custom_shared_home_info.dart';
import 'package:flutter/material.dart';

class NextLessonWidget extends StatelessWidget {
  const NextLessonWidget({super.key, required this.widgetSession});
  final Widget widgetSession;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          CustomIconBox(
            imagePath: ImageManager.teacherMeetingIcon,
            height: 12,
            width: 20,
          ),
          const SizedBox(width: 8),
          CustomSharedHomeInfo(title: 'الرياضيات-احمد محمد', subtitle: '6:00م'),
          Spacer(),
          widgetSession,
        ],
      ),
    );
  }
}
