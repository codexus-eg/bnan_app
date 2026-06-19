import 'package:bnan_app/features/teacher_assignment/presentation/widgets/dialogs/custom_app_dialog.dart';
import 'package:flutter/material.dart';
import 'create_assignment_form.dart';

class CreateAssignmentDialog extends StatelessWidget {
  const CreateAssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppDialog(
      child: CreateAssignmentForm(),
    );
  }
}