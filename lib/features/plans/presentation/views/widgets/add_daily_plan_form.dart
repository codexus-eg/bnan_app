import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_state.dart';
import 'package:bnan_app/features/plans/presentation/mappers/add_plan_error_message_mapper.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_select_fields.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialog_error_message.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDailyPlanForm extends StatefulWidget {
  const AddDailyPlanForm({
    super.key,
    required this.policy,
    required this.classroom,
    required this.selectedWeek,
    required this.startDate,
  }) : assert(selectedWeek > 0);

  final PlansAccessPolicy policy;
  final PlanClassroomOption classroom;
  final int selectedWeek;
  final DateTime startDate;

  @override
  State<AddDailyPlanForm> createState() => _AddDailyPlanFormState();
}

class _AddDailyPlanFormState extends State<AddDailyPlanForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _lessonController = TextEditingController();
  final _homeworkController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedSubjectId;

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
    return BlocConsumer<PlansActionsCubit, PlansActionsState>(
      listenWhen: (_, state) =>
          state is CreateDailyPlanSuccess || state is CreateDailyPlanFailure,
      listener: (context, state) {
        if (state is CreateDailyPlanSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.addDailyPlanForStudents),
            const SizedBox(height: 16),
            AddDailyPlanSelectFields(
              policy: widget.policy,
              classroom: widget.classroom,
              dateController: _dateController,
              selectedDate: _selectedDate,
              startDate: widget.startDate,
              onDateChanged: (date) => setState(() => _selectedDate = date),
              onTeacherChanged: (_) {},
              onSubjectChanged: (value) => _selectedSubjectId = value,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: s.lessonLabel,
              controller: _lessonController,
              isRequired: true,
              backgroundColor: ColorManager.white,
              validator: (value) =>
                  MyValidator.requiredField(value, s.lessonLabel),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: s.homeworkLabel,
              controller: _homeworkController,
              backgroundColor: ColorManager.white,
              isRequired: true,
              validator: (value) =>
                  MyValidator.requiredField(value, s.homeworkLabel),
            ),
            const SizedBox(height: 16),
            if (state is CreateDailyPlanFailure) ...[
              PlansDialogErrorMessage(
                message: mapAddPlanErrorMessage(
                  state.message,
                  duplicateMessage: s.dailyPlanAlreadyUploaded,
                ),
              ),
              const SizedBox(height: 16),
            ],
            CustomAppButton(
              text: s.addAction,
              isLoading: state is CreateDailyPlanLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (context.read<PlansActionsCubit>().state is CreateDailyPlanLoading) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final date = _selectedDate!;
    final subjectId = _selectedSubjectId!;
    context.read<PlansActionsCubit>().createDailyPlan(
      classroomId: widget.classroom.id,
      subjectId: subjectId,
      request: CreateDailyPlanRequestModel(
        day: _apiDate(date),
        sessionContent: _lessonController.text.trim(),
        sessionAssignment: _homeworkController.text.trim(),
      ),
    );
  }

  String _apiDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
