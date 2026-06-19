import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_group_info_row.dart';
import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  const CardContent({
    super.key,
    required this.title,
    required this.studentsCount,
    required this.secondText,
    required this.secondIconPath, required this.needSecondIcon,
  });

  final String title;
  final int studentsCount;
  final String secondText;
  final String secondIconPath;
    final bool needSecondIcon;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: StylesManager.styleBold14(context)),
        const SizedBox(height: 4),
        TeacherGroupInfoRow(
          needSecondIcon: needSecondIcon,
          studentsCount: studentsCount,
          secondText: secondText,
          secondIconPath: secondIconPath,
        ),
      ],
    );
  }
}
