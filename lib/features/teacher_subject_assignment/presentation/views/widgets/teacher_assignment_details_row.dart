import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherAssignmentDetailsRow extends StatelessWidget {
  const TeacherAssignmentDetailsRow({
    super.key,
    required this.row,
    required this.onTap,
  });

  final AssignmentRowItem row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImageManager.teacherBookTwoIcon,
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(
              ColorManager.mainColor14,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _details,
                  softWrap: true,
                  style: StylesManager.styleMedium14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                Customship(row.curriculumName),
              ],
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onTap,
            child: SvgPicture.asset(ImageManager.trash, height: 24, width: 4),
          ),
        ],
      ),
    );
  }

  String get _details =>
      '${_value(row.gradeName)} - ${_value(row.classroomName)} - '
      '${_value(row.subjectName)}';

  String _value(String value) => value.trim().isEmpty ? '-' : value.trim();
}
