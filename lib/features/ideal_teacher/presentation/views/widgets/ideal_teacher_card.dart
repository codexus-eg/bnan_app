import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_card_content.dart';
import 'package:flutter/material.dart';

class IdealTeacherCard extends StatelessWidget {
  const IdealTeacherCard({
    super.key,
    required this.teacher,
    required this.selected,
    required this.onTap,
    this.canSelect = true,
  });
  final SupervisorTeacherModel teacher;
  final bool selected;
  final VoidCallback? onTap;
  final bool canSelect;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: CustomDetailsWidgetBackground(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: const EdgeInsetsDirectional.all(12),
      backgroundColor: (selected && canSelect) ? ColorManager.blueE5 : ColorManager.greyF8F9,
      child: IdealTeacherCardContent(
        teacher: teacher,
        selected: selected,
        canSelect: canSelect,
      ),
    ),
  );
}
