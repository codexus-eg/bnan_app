import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_details_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomsManagementCard extends StatelessWidget {
  const ClassroomsManagementCard({
    super.key,
    required this.classroomItem,
    this.onView,
    this.onEdit,
  });

  final ClassroomModel classroomItem;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomDetailsWidgetBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classroomItem.name,
            style: StylesManager.styleBold10(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 8),
          ClassroomsManagementDetailsCard(s: s, classroomItem: classroomItem),
          const SizedBox(height: 4),
          ClassMetaRow(label: s.teachers, value: _teacherNames(classroomItem)),
          const SizedBox(height: 8),
          Row(
            children: [
              ActionChipButton(
                title: s.view,
                icon: ImageManager.usersManagementEyeOpenIcon,
                onTap: onView,
              ),
              const SizedBox(width: 12),
              ActionChipButton(
                title: s.edit,
                icon: ImageManager.usersManagementEditIcon,
                onTap: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _teacherNames(ClassroomModel classroom) {
  final names = classroom.teachers.map((teacher) => teacher.fullName).toList();
  return names.isEmpty ? '-' : names.join(' - ');
}
