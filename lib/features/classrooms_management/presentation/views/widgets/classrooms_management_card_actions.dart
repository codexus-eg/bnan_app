import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomsManagementCardActions extends StatelessWidget {
  const ClassroomsManagementCardActions({
    super.key,
    this.onView,
    this.onEdit,
    this.onSubjects,
  });

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onSubjects;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChipButton(
          title: s.view,
          icon: ImageManager.usersManagementEyeOpenIcon,
          onTap: onView,
        ),
        ActionChipButton(
          title: s.edit,
          icon: ImageManager.usersManagementEditIcon,
          onTap: onEdit,
        ),
        if (onSubjects != null)
          ActionChipButton(
            title: s.classroomSubjects,
            icon: ImageManager.bookIcon,
            onTap: onSubjects,
          ),
      ],
    );
  }
}
