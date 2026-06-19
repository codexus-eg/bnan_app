import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/teacher_assignment_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentSubmissionFooter extends StatelessWidget {
  const StudentSubmissionFooter({super.key, required this.buttonText});

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(ImageManager.teacherAssignmentPaperclipIcon),
                const SizedBox(width: 4),
                Text(
                  'ahmed_hw.jpg',
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ],
            ),
            SvgPicture.asset(
              ImageManager.downloadIcon,
              colorFilter: ColorFilter.mode(
                ColorManager.greyA8AF,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 30,
          child: CustomAppButton(
            text: buttonText,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.white),
            onPressed: ()=>TeacherAssignmentDialogs.showSubmitCorrection(context),
          ),
        ),
      ],
    );
  }
}
