import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'create_assignment_fields.dart';

class CreateAssignmentForm extends StatefulWidget {
  const CreateAssignmentForm({super.key});

  @override
  State<CreateAssignmentForm> createState() => _CreateAssignmentFormState();
}

class _CreateAssignmentFormState extends State<CreateAssignmentForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deliveryDateController = TextEditingController();

  String? selectedClass;
  String? selectedSubject;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deliveryDateController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               CustomDialogHeader(title: S.of(context).createNewAssignment),
              const SizedBox(height: 16),
              CreateAssignmentFields(
                titleController: titleController,
                descriptionController: descriptionController,
                deliveryDateController: deliveryDateController,
                selectedClass: selectedClass,
                selectedSubject: selectedSubject,
                onClassChanged: (value) {
                  setState(() => selectedClass = value);
                },
                onSubjectChanged: (value) {
                  setState(() => selectedSubject = value);
                },
              ),
              const SizedBox(height: 16),
              CustomAppButton(
                text: S.of(context).createAssignment,
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}