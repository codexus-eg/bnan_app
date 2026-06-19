import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAssignmentFields extends StatefulWidget {
  const CreateAssignmentFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.deliveryDateController,
    required this.selectedClass,
    required this.selectedSubject,
    required this.onClassChanged,
    required this.onSubjectChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController deliveryDateController;
  final String? selectedClass;
  final String? selectedSubject;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onSubjectChanged;

  @override
  State<CreateAssignmentFields> createState() => _CreateAssignmentFieldsState();
}

class _CreateAssignmentFieldsState extends State<CreateAssignmentFields> {
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  Future<void> _pickDate() async {
    final date = await AppPickers.pickDate(
      context: context,
      initialDate: selectedDate,
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: S.of(context).assignmentTitle,
          backgroundColor: ColorManager.white,
          isRequired: true,
          controller: widget.titleController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).assignmentDescription,
          backgroundColor: ColorManager.white,
          controller: widget.descriptionController,
          maxLine: 3,
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: S.of(context).classRoom,
          isRequired: true,
          hintStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
          hint: S.of(context).chooseClassRoom,
          value: widget.selectedClass,
          items: const ['الفصل الأول', 'الفصل الثاني'],
          onChanged: widget.onClassChanged,
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: S.of(context).subject,
          isRequired: true,
          hint: S.of(context).chooseSubject,
          hintStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
          value: widget.selectedSubject,
          items: const ['رياضيات', 'علوم'],
          onChanged: widget.onSubjectChanged,
        ),
        const SizedBox(height: 16),
        SchedulePickerField(
          label: S.of(context).availableDay,
          hintText: 'mm/dd/yy',
          value: selectedDate == null ? null : _formatDate(selectedDate!),
          icon:ImageManager.teacherAssignmentDateIcon,
          onTap: _pickDate,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).attachmentFile,
          hintText: S.of(context).chooseFile,
          readOnly: true,
          hintStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: SvgPicture.asset(
              ImageManager.teacherAssignmentPaperclipIcon,
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }
}
