import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/supervisor_assignment_dialog_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelSupervisorAssignmentDialog extends StatefulWidget {
  const CancelSupervisorAssignmentDialog({
    super.key,
    required this.supervisorId,
    required this.getSupervisorsCubit,
    required this.actionsCubit,
    required this.classroomId,
    required this.classroomName,
  });

  final String supervisorId;
  final GetSupervisorsCubit getSupervisorsCubit;
  final SupervisorAssignmentActionsCubit actionsCubit;
  final String classroomId;
  final String classroomName;

  @override
  State<CancelSupervisorAssignmentDialog> createState() =>
      _CancelSupervisorAssignmentDialogState();
}

class _CancelSupervisorAssignmentDialogState
    extends State<CancelSupervisorAssignmentDialog> {
  String? errorMessage;

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
            state is UnassignSupervisorLoading &&
            state.supervisorId == widget.supervisorId &&
            state.classroomId == widget.classroomId;
        return CustomAppDialog(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(title: s.cancelAssignment),
                const SizedBox(height: 16),
                Text(
                  s.cancelSupervisorAssignmentQuestion(widget.classroomName),
                  textAlign: TextAlign.center,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  SupervisorAssignmentDialogError(message: errorMessage!),
                ],
                const SizedBox(height: 16),
                Row(children: _buttons(context, s, loading)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buttons(BuildContext context, S s, bool loading) => [
    Expanded(
      child: CustomAppButton(
        text: s.yes,
        height: 40,
        isLoading: loading,
        onPressed:
            widget.supervisorId.isEmpty || widget.classroomId.isEmpty || loading
            ? null
            : _submit,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: CustomAppButton(
        text: s.no,
        height: 40,
        onPressed: loading ? null : () => Navigator.pop(context),
        backgroundColor: ColorManager.white,
        borderColor: ColorManager.blueE3,
        textColor: ColorManager.mainColor15,
      ),
    ),
  ];

  void _submit() {
    setState(() => errorMessage = null);
    widget.actionsCubit.unassignSupervisorFromClassroom(
      supervisorId: widget.supervisorId,
      classroomId: widget.classroomId,
    );
  }

  void _onActionState(
    BuildContext context,
    SupervisorAssignmentActionsState state,
  ) {
    if (state is UnassignSupervisorSuccess &&
        state.supervisorId == widget.supervisorId &&
        state.classroomId == widget.classroomId) {
      setState(() => errorMessage = null);
      widget.getSupervisorsCubit.getSupervisors();
      showCustomSnackBar(
        context,
        S.of(context).assignmentRemovedSuccessfully,
        true,
      );
      Navigator.pop(context);
    } else if (state is UnassignSupervisorFailure &&
        state.supervisorId == widget.supervisorId &&
        state.classroomId == widget.classroomId) {
      setState(() => errorMessage = state.errorMessage);
    }
  }
}
