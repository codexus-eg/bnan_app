import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectCardManagement extends StatelessWidget {
  const SubjectCardManagement({super.key, required this.subject, this.onEdit});

  final SubjectModel? subject;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final gradeName = subject?.grade?.name?.trim();
    return CustomDetailsWidgetBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject?.name ?? 'اسم المادة',
            style: StylesManager.styleBold10(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 8),
          ClassMetaRow(
            label: S.of(context).curriculum,
            value: subject?.curriculum?.name ?? '---',
          ),
          if (gradeName != null && gradeName.isNotEmpty)
            ClassMetaRow(label: S.of(context).grade, value: gradeName),
          const SizedBox(height: 8),
          ActionChipButton(
            title: S.of(context).edit,
            icon: ImageManager.usersManagementEditIcon,
            onTap: onEdit,
          ),
        ],
      ),
    );
  }
}
