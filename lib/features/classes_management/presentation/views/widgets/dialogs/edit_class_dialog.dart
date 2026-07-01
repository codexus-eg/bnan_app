import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classes_management/data/models/class_management_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditClassDialog extends StatefulWidget {
  const EditClassDialog({super.key, required this.classItem});
  final ClassManagementModel classItem;

  @override
  State<EditClassDialog> createState() => EditClassDialogState();
}

class EditClassDialogState extends State<EditClassDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController classNameController;
  late final TextEditingController supervisorController;
  String? supervisor;

  @override
  void initState() {
    super.initState();
    classNameController = TextEditingController(text: widget.classItem.title);
    supervisorController = TextEditingController(
      text: widget.classItem.supervisor,
    );
  }

  @override
  void dispose() {
    classNameController.dispose();
    supervisorController.dispose();
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
              CustomDialogHeader(title: s.editClass),
              const SizedBox(height: 16),
              CustomTextField(
                label: s.className,
                hintStyle: getStyle(context),
                controller: classNameController,
                backgroundColor: ColorManager.white,
              ),
              const SizedBox(height: 16),
               CustomDropdownFormField(
                label: s.theSupervisor,
                labelColor: ColorManager.mainColor14,
                hint: supervisorController.text,
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

  TextStyle getStyle(context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.mainColor14);
  }

  void submit() {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }
}
