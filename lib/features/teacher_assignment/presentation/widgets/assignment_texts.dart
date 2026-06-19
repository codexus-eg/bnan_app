import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:flutter/material.dart';

class AssignmentTexts extends StatelessWidget {
  const AssignmentTexts({super.key, required this.assignment});

  final TeacherAssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          assignment.title,
          style:StylesManager.styleBold16(context).copyWith(
            color: ColorManager.black
          )
        ),
        const SizedBox(height: 7),
        Text(
          '${assignment.className} | ${assignment.subject}',
          style: StylesManager.styleRegular15(context)
        ),
        const SizedBox(height: 7),
        Text(
          assignment.description,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF
          )
        ),
      ],
    );
  }
}