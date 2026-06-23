import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/card_content.dart';
import 'package:flutter/material.dart';

class TeacherGroupCard extends StatelessWidget {
  const TeacherGroupCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.studentsCount,
    required this.secondText,
    required this.secondIconPath,
    this.onTap,
    required this.needSecondIcon,
  });

  final String title;
  final String iconPath;
  final int studentsCount;
  final String secondText;
  final String secondIconPath;
  final VoidCallback? onTap;
  final bool needSecondIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),

      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 16),
        child: CustomDetailsWidgetBackground(
          child: Row(
            children: [
              CustomIconBox(imagePath: iconPath),
              const SizedBox(width: 8),
              Expanded(
                child: CardContent(
                  title: title,
                  needSecondIcon: needSecondIcon,
                  studentsCount: studentsCount,
                  secondText: secondText,
                  secondIconPath: secondIconPath,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
