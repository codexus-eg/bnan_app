import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/teacher_profile_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomTeacherExtraWidget extends StatelessWidget {
  const CustomTeacherExtraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<HomeStateModel> states = [
      HomeStateModel(
        icon: ImageManager.userProfileGroupIcon,
        value: '12',
        title: S.of(context).student,
      ),
      HomeStateModel(
        icon: ImageManager.teacherBookTwoIcon,
        value: '8',
        title: S.of(context).sections,
      ),
      HomeStateModel(
        icon: ImageManager.teacherGraduationCapIcon,
        value: '4',
        title: S.of(context).classes,
      ),
      HomeStateModel(
        icon: ImageManager.teacherBookOneIcon,
        value: '4',
        title: S.of(context).subjects,
      ),
    ];
    return CustomDetailsWidgetBackground(
      child: Row(
        children: List.generate(states.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const SizedBox(width: 20);
          }
          final itemIndex = index ~/ 2;
          return Expanded(
            child: TeacherProfileInfo(profileInfo: states[itemIndex]),
          );
        }),
      ),
    );
  }
}
