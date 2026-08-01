import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/evaluation_score_fields.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/week_start_field.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_select_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationForm extends StatefulWidget {
  const WeeklyEvaluationForm({
    super.key,
    required this.title,
    this.evaluation,
    this.onSave,
  });

  final String title;
  final WeeklyEvaluationModel? evaluation;
  final VoidCallback? onSave;

  @override
  State<WeeklyEvaluationForm> createState() => _WeeklyEvaluationFormState();
}

class _WeeklyEvaluationFormState extends State<WeeklyEvaluationForm> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.evaluation?.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: widget.title),
          const SizedBox(height: 16),
          WeeklyEvaluationSelectFields(evaluation: widget.evaluation),
          const SizedBox(height: 16),
          WeekStartField(value: widget.evaluation?.weekStart),
          const SizedBox(height: 16),
          EvaluationScoreFields(evaluation: widget.evaluation),
          const SizedBox(height: 16),
          CustomTextField(
            label: s.notesText,
            controller: _notesController,
            maxLine: 3,
            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          CustomAppButton(text: s.save, onPressed: _save),
        ],
      ),
    );
  }

  void _save() {
    widget.onSave?.call();
    Navigator.of(context).pop();
  }
}
