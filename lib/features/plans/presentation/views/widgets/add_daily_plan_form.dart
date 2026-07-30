import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_select_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddDailyPlanForm extends StatefulWidget {
  const AddDailyPlanForm({super.key, required this.policy});

  final PlansAccessPolicy policy;

  @override
  State<AddDailyPlanForm> createState() => _AddDailyPlanFormState();
}

class _AddDailyPlanFormState extends State<AddDailyPlanForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _lessonController = TextEditingController();
  final _homeworkController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _lessonController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: s.addDailyPlanForStudents),
          const SizedBox(height: 16),
          AddDailyPlanSelectFields(
            policy: widget.policy,
            dateController: _dateController,
            onGradeChanged: (_) {},
            onTeacherChanged: (_) {},
            onSubjectChanged: (_) {},
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: s.lessonLabel,
            controller: _lessonController,
            maxLine: 2,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: s.homeworkLabel,
            controller: _homeworkController,
            maxLine: 2,
          ),
          const SizedBox(height: 14),
          CustomAppButton(text: s.addAction, onPressed: _submit),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }
}
