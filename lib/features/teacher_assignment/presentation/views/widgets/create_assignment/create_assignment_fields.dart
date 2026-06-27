import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_attachment_field.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_date_field.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_dropdowns.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_text_fields.dart';
import 'package:flutter/material.dart';

class CreateAssignmentFields extends StatelessWidget {
  const CreateAssignmentFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CreateAssignmentTextFields(),
        SizedBox(height: 16),
        CreateAssignmentDropdowns(),
        SizedBox(height: 16),
        CreateAssignmentDateField(),
        SizedBox(height: 16),
        CreateAssignmentAttachmentField(),
      ],
    );
  }
}