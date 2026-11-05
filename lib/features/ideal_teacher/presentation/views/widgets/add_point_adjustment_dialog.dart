import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPointAdjustmentDialog extends StatefulWidget {
  const AddPointAdjustmentDialog({
    super.key,
    required this.teacherId,
    required this.teacherName,
  });

  final String teacherId, teacherName;

  static Future<void> show(
    BuildContext context, {
    required String teacherId,
    required String teacherName,
  }) => showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<SupervisorIdealTeacherCubit>(),
      child: AddPointAdjustmentDialog(
        teacherId: teacherId,
        teacherName: teacherName,
      ),
    ),
  );

  @override
  State<AddPointAdjustmentDialog> createState() =>
      _AddPointAdjustmentDialogState();
}

class _AddPointAdjustmentDialogState extends State<AddPointAdjustmentDialog> {
  final _reasonController = TextEditingController();
  int _points = 1;
  String _category = 'interactive_environment';
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final categories = {
      'interactive_environment': s.interactiveEnvironment,
      'weekly_tasks': s.weeklyTasks,
      'effort': s.effort,
      'other': s.other,
    };

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDialogHeader(title: s.addPoints),
              const SizedBox(height: 12),
              Text(
                widget.teacherName,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: s.pointsAmount,
                items: const ['1', '2', '3', '4', '5'],
                value: '$_points',
                onChanged: (p) =>
                    setState(() => _points = int.tryParse(p ?? '') ?? 1),
              ),
              const SizedBox(height: 12),
              CustomDropdown(
                label: s.category,
                items: categories.keys.toList(),
                itemsLabels: categories,
                value: _category,
                onChanged: (cat) =>
                    setState(() => _category = cat ?? 'interactive_environment'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _reasonController,
                hintText: s.reason,
                maxLine: 2,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomAppButton(
                      text: s.cancel,
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      backgroundColor: ColorManager.white,
                      borderColor: ColorManager.blueE3,
                      textColor: ColorManager.mainColor15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomAppButton(
                      text: s.addPoints,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      showCustomSnackBar(context, S.of(context).reasonRequired, false);
      return;
    }
    setState(() => _isLoading = true);
    final success = await context
        .read<SupervisorIdealTeacherCubit>()
        .addPointAdjustment(
          teacherId: widget.teacherId,
          points: _points,
          category: _category,
          reason: reason,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (success) {
      showCustomSnackBar(
        context,
        S.of(context).pointAdjustmentAddedSuccessfully,
        true,
      );
      Navigator.pop(context);
    }
  }
}
