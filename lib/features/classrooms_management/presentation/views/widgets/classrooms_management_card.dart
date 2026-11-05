import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_card_actions.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/classrooms_management_details_card.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/shared_classroom_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomsManagementCard extends StatelessWidget {
  const ClassroomsManagementCard({
    super.key,
    required this.classroomItem,
    this.onView,
    this.onEdit,
    this.onSubjects,
  });

  final ClassroomModel classroomItem;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onSubjects;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final teachers = classroomItem.teachers.map((t) => t.fullName).toList();

    return CustomDetailsWidgetBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(classroomItem.name,
                    style: StylesManager.styleBold10(context)
                        .copyWith(color: ColorManager.mainColor14)),
              ),
              if (classroomItem.isShared) const SharedClassroomBadge(),
            ],
          ),
          const SizedBox(height: 8),
          ClassroomsManagementDetailsCard(s: s, classroomItem: classroomItem),
          const SizedBox(height: 4),
          ClassMetaRow(label: s.teachers, value: teachers.isEmpty ? '-' : teachers.join(' - ')),
          const SizedBox(height: 8),
          ClassroomsManagementCardActions(onView: onView, onEdit: onEdit, onSubjects: onSubjects),
        ],
      ),
    );
  }
}
