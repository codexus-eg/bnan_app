import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassDialog extends StatefulWidget {
  const AddClassDialog({super.key});

  @override
  State<AddClassDialog> createState() => AddClassDialogState();
}

class AddClassDialogState extends State<AddClassDialog> {
  final formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  String? curriculum;
  String? grade;
  String? supervisor;

  @override
  void dispose() {
    classNameController.dispose();
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
              CustomDialogHeader(title: s.addNewChapter),
              const SizedBox(height: 16),
              CustomTextField(
                hintStyle: getStyle(context),
                label: s.className,
                labelColor: ColorManager.mainColor14,
                controller: classNameController,
                backgroundColor: ColorManager.white,
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.curriculum,
                hint: s.curriculum,
                labelColor: ColorManager.mainColor14,
                hintStyle: getStyle(context),
                items: const ['المنهج السعودي', 'المنهج المصري'],
                value: curriculum,
                onChanged: (value) => setState(() => curriculum = value),
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.grade,
                labelColor: ColorManager.mainColor14,
                hint: s.chooseGrade,
                items: const ['الصف الأول', 'الصف الثالث الإعدادي'],
                value: grade,
                hintStyle: getStyle(context),
                onChanged: (value) => setState(() => grade = value),
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.theSupervisor,
                labelColor: ColorManager.mainColor14,
                hint: s.supervisor,
                hintStyle: getStyle(context),
                items: const ['نورا أحمد', 'هدير أحمد'],
                value: supervisor,
                onChanged: (value) => setState(() => supervisor = value),
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
    ).copyWith(color: ColorManager.mainColor14);
  }
}
