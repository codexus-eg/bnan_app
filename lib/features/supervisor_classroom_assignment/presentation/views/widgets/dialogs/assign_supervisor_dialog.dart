import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/supervisor_classroom_picker.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/supervisor_assignment_dialog_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignSupervisorDialog extends StatefulWidget {
  const AssignSupervisorDialog({
    super.key,
    required this.supervisorId,
    required this.getSupervisorsCubit,
    required this.actionsCubit,
    required this.supervisorName,
    required this.curriculumId,
    required this.curriculumName,
    required this.assignedClassroomIds,
  });

  final String supervisorId;
  final GetSupervisorsCubit getSupervisorsCubit;
  final SupervisorAssignmentActionsCubit actionsCubit;
  final String supervisorName;
  final String curriculumId;
  final String curriculumName;
  final Set<String> assignedClassroomIds;

  @override
  State<AssignSupervisorDialog> createState() => _AssignSupervisorDialogState();
}

class _AssignSupervisorDialogState extends State<AssignSupervisorDialog> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.curriculumId.isEmpty) return;
      context.read<AcademicLookupsCubit>().selectCurriculum(
        AcademicCurriculumModel(
          id: widget.curriculumId,
          name: widget.curriculumName,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<
      SupervisorAssignmentActionsCubit,
      SupervisorAssignmentActionsState
    >(
      bloc: widget.actionsCubit,
      listener: _onActionState,
      builder: (context, state) {
        final loading =
            state is AssignSupervisorLoading &&
            state.supervisorId == widget.supervisorId;
        return CustomAppDialog(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(
                  title: s.assignSupervisorToClassroom(widget.supervisorName),
                ),
                const SizedBox(height: 16),
                SupervisorClassroomPicker(
                  assignedClassroomIds: widget.assignedClassroomIds,
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  SupervisorAssignmentDialogError(message: errorMessage!),
                ],
                const SizedBox(height: 16),
                BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
                  builder: (context, lookupState) {
                    final hasAvailableClassroom = lookupState.classrooms.any(
                      (item) => !widget.assignedClassroomIds.contains(item.id),
                    );
                    return CustomAppButton(
                      text: s.save,
                      isLoading: loading,
                      onPressed:
                          widget.curriculumId.isEmpty ||
                              lookupState.grades.isEmpty ||
                              !hasAvailableClassroom
                          ? null
                          : _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final classroomId = context
        .read<AcademicLookupsCubit>()
        .state
        .selectedClassroom
        ?.id;
    if (classroomId == null || classroomId.isEmpty) {
      showCustomSnackBar(context, S.of(context).classroomRequired, false);
      return;
    }
    setState(() => errorMessage = null);
    widget.actionsCubit.assignSupervisorToClassrooms(
      supervisorId: widget.supervisorId,
      classroomIds: [classroomId],
    );
  }

  void _onActionState(
    BuildContext context,
    SupervisorAssignmentActionsState state,
  ) {
    if (state is AssignSupervisorSuccess &&
        state.supervisorId == widget.supervisorId) {
      setState(() => errorMessage = null);
      widget.getSupervisorsCubit.getSupervisors();
      showCustomSnackBar(
        context,
        S.of(context).assignmentAddedSuccessfully,
        true,
      );
      Navigator.pop(context);
    } else if (state is AssignSupervisorFailure &&
        state.supervisorId == widget.supervisorId) {
      setState(() => errorMessage = state.errorMessage);
    }
  }
}
