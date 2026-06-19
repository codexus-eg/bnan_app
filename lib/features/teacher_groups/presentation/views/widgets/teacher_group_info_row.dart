import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_group_info_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherGroupInfoRow extends StatelessWidget {
  const TeacherGroupInfoRow({
    super.key,
    required this.studentsCount,
    required this.secondText,
    required this.secondIconPath,
    this.needSecondIcon = true,
  });

  final int studentsCount;
  final String secondText;
  final String secondIconPath;
  final bool needSecondIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TeacherGroupInfoItem(
          iconPath: ImageManager.userProfileGroupIcon,
          text: '$studentsCount ${S.of(context).student}',
        ),
        const SizedBox(width: 4),
        TeacherGroupInfoItem(
          iconPath: needSecondIcon ? secondIconPath : null,
          text: needSecondIcon
              ? secondText
              : '$secondText ${S.of(context).classR}',
        ),
      ],
    );
  }
}