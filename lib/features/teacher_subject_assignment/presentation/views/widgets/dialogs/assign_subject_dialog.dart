import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignSubjectDialog extends StatefulWidget {
  const AssignSubjectDialog({super.key, required this.teacherName});
  final String teacherName;

  @override
  State<AssignSubjectDialog> createState() => AssignSubjectDialogState();
}

class AssignSubjectDialogState extends State<AssignSubjectDialog> {
  final formKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  String? curriculum, subject;

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(
                title: s.assignTeacherInSubject(widget.teacherName),
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.curriculum,
                labelColor: ColorManager.mainColor14,
                hint: s.curriculum,
                hintStyle: getStyle(context),
                items: const ['مصري', 'سعودي'],
                value: curriculum,
                onChanged: (value) => setState(() => curriculum = value),
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.chooseSubject,
                labelColor: ColorManager.mainColor14,
                hint: s.subject,
                items: const ['Math', 'English', 'الرياضيات'],
                value: subject,
                hintStyle: getStyle(context),
                onChanged: (value) => setState(() => subject = value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: s.hourlyRate,
                controller: priceController,
                labelColor: ColorManager.mainColor14,
                keyboardType: TextInputType.number,
                hintStyle: getStyle(context),
              ),
              const SizedBox(height: 16),
              CustomAppButton(text: s.save, onPressed: submit),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }

  TextStyle getStyle(context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.greyA8AF);
  }
}
