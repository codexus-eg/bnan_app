import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssignmentFooter extends StatelessWidget {
  const AssignmentFooter({super.key, required this.assignment});

  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _assignmentFooter(
          assignment.formattedDueDate,
          ImageManager.teacherAssignmentDateIcon,
          context,
        ),
        const SizedBox(width: 8),
        _assignmentFooter(
          assignment.submissionsText,
          ImageManager.userProfileGroupIcon,
          context,
        ),
      ],
    );
  }
}

Widget _assignmentFooter(String title, String image, context) {
  return Row(
    children: [
      SvgPicture.asset(
        image,
        height: 24,
        width: 24,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(ColorManager.greyA8AF, BlendMode.srcIn),
      ),
      const SizedBox(width: 4),
      Text(title, style: StylesManager.styleRegular15(context)),
    ],
  );
}
