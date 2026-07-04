import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/info_text.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_mock_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_application_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_details_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherApplicationCard extends StatelessWidget {
  const TeacherApplicationCard({super.key, required this.teacher});
  final TeacherApplicationModel teacher;
  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        children: [
          CardHeader(
            name: teacher.teacherName,
            phone: teacher.phone,
            subtitle: teacher.status,
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClassMetaRow(
                      label: '${S.of(context).specialization}: ',
                      value: teacher.specialization,
                    ),
                    ClassMetaRow(
                      label: '${S.of(context).subjects}: ',
                      value: teacher.subjects.join('، '),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: InfoText(
                  label: S.of(context).experience,
                  value: teacher.experienceYears,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusActionButton(
                title: S.of(context).accept,
                icon: Icons.check,
                backgroundColor: ColorManager.orangeF9,
                onPressed: () {},
              ),
              StatusActionButton(onPressed: () {}),
              ActionChipButton(
                title: S.of(context).cv,
                icon: ImageManager.fileIcon,
                onTap: () {},
              ),
              ActionChipButton(
                title: S.of(context).details,
                icon: ImageManager.usersManagementEyeOpenIcon,
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => TeacherApplicationDetailsDialog(
                    teacher: teacher,
                    details: teacherApplicationDetailsMockData[teacher.id]!,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
