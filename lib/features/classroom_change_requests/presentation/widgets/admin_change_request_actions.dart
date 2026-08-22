import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_request_actions_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_request_actions_state.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/request_notes_dialog.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestActions extends StatelessWidget {
  const AdminChangeRequestActions({
    super.key,
    required this.requestId,
    required this.classroomSubjectId,
    this.navigateAfterApproval = false,
  });

  final String requestId;
  final String classroomSubjectId;
  final bool navigateAfterApproval;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminChangeRequestActionsCubit>();

    return Row(
      children: [
        Expanded(
          child: RegistrationFilledButton(
            title: S.of(context).adminSubjectRequestApprove,
            color: ColorManager.orangeF9,
            icon: Icons.check,
            isLoading: cubit.loading(
              requestId,
              AdminChangeRequestAction.approve,
            ),
            onPressed: () => _approve(context),
          ),
        ),
        const SizedBox(width: 22),
        StatusActionButton(
          isLoading: cubit.loading(requestId, AdminChangeRequestAction.reject),
          onPressed: () => _reject(context),
        ),
      ],
    );
  }

  Future<void> _approve(BuildContext context) async {
    if (classroomSubjectId.trim().isEmpty) {
      showCustomSnackBar(
        context,
        S.of(context).gulfClassroomSubjectUnavailable,
        false,
      );
      return;
    }
    final navigator = Navigator.of(context);
    final cubit = context.read<AdminChangeRequestActionsCubit>();
    final result = await showDialog<RequestNotesResult>(
      context: context,
      builder: (_) => RequestNotesDialog(
        title: S.of(context).approveRequest,
        label: S.of(context).adminNotes,
        required: false,
        onSubmit: (result) async {
          await cubit.approve(requestId, classroomSubjectId, result.notes);
          final state = cubit.state;
          return state is AdminChangeRequestActionSuccess &&
              state.id == requestId &&
              state.action == AdminChangeRequestAction.approve;
        },
      ),
    );
    if (result != null && navigateAfterApproval && navigator.mounted) {
      MyNavigator.goTo(navigator.context, Routes.teacherSubjectAssignmentView);
    }
  }

  Future<void> _reject(BuildContext context) async {
    final result = await showDialog<RequestNotesResult>(
      context: context,
      builder: (_) => RequestNotesDialog(
        title: S.of(context).rejectRequest,
        label: S.of(context).rejectionReason,
      ),
    );

    if (result != null && context.mounted) {
      await context.read<AdminChangeRequestActionsCubit>().reject(
        requestId,
        result.notes,
      );
    }
  }
}
