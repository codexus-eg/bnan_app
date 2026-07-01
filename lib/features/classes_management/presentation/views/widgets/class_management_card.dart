import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classes_management/data/models/class_management_model.dart';
import 'package:bnan_app/features/classes_management/presentation/views/widgets/classes_management_details_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassManagementCard extends StatelessWidget {
  const ClassManagementCard({
    super.key,
    required this.classItem,
    this.onView,
    this.onEdit,
  });

  final ClassManagementModel classItem;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomDetailsWidgetBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classItem.title,
            style: StylesManager.styleBold10(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 8),
          ClassesMnagementDetailsCard(s: s, classItem: classItem),
          const SizedBox(height: 4),
          ClassMetaRow(label: s.teachers, value: classItem.teachers),
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
