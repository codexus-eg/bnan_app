import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/schedule_attachment_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassScheduleForm extends StatelessWidget {
  const ClassScheduleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: s.classSchedulesManagement),
          const SizedBox(height: 16),
          CustomDropdown(
            label: s.curriculum,
            isRequired: true,
            hintStyle: StylesManager.styleRegular16(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
            hint: s.chooseNewCurriculum,
            items: const ['المنهج السعودي', 'المنهج المصري'],
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          CustomDropdown(
            label: s.grade,
            hintStyle: StylesManager.styleRegular16(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
            isRequired: true,
            hint: s.chooseGrade,
            items: const ['الصف الأول الإعدادي', 'الصف الثاني الإعدادي'],
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          const ScheduleAttachmentField(),
          const SizedBox(height: 16),
          CustomAppButton(text: s.uploadSchedule, onPressed: () {}),
        ],
      ),
    );
  }
}
