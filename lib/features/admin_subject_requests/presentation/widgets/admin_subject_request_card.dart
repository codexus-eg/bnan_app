import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_state.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_request_approval_dialog.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_request_info.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_request_status_label.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestCard extends StatelessWidget {
  const AdminSubjectRequestCard({super.key, required this.request});
  final AdminSubjectRequestModel request;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<
        AdminSubjectRequestActionsCubit,
        AdminSubjectRequestActionsState
      >(
        listenWhen: (_, state) => _matches(state),
        listener: _onAction,
        builder: (context, _) {
          final actions = context.read<AdminSubjectRequestActionsCubit>();
          final awaiting = request.status == 'awaiting_admin_approval';
          return CustomDetailsWidgetBackground(
            child: Column(
              children: [
                CardHeader(
                  name: request.studentName,
                  phone: request.studentPhone,
                  subtitle: adminSubjectRequestStatusLabel(
                    S.of(context),
                    request.status,
                  ),
                ),
                const SizedBox(height: 8),
                AdminSubjectRequestInfo(request: request),
                if (awaiting) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RegistrationFilledButton(
                          title: S.of(context).adminSubjectRequestApprove,
                          color: ColorManager.orangeF9,
                          icon: Icons.check,
                          isLoading: actions.isLoading(
                            request.id,
                            AdminSubjectRequestAction.approve,
                          ),
                          onPressed: () => _approve(context),
                        ),
                      ),
                      const SizedBox(width: 22),
                      StatusActionButton(
                        isLoading: actions.isLoading(
                          request.id,
                          AdminSubjectRequestAction.reject,
                        ),
                        onPressed: () => actions.reject(request.id),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );

  bool _matches(AdminSubjectRequestActionsState state) => switch (state) {
    AdminSubjectRequestActionLoading(:final requestId) ||
    AdminSubjectRequestActionSuccess(:final requestId) ||
    AdminSubjectRequestActionFailure(
      :final requestId,
    ) => requestId == request.id,
    _ => false,
  };

  Future<void> _approve(BuildContext context) async {
    final approval = await showDialog<AdminSubjectRequestApproval>(
      context: context,
      builder: (_) => const AdminSubjectRequestApprovalDialog(),
    );
    if (approval != null && context.mounted) {
      await context.read<AdminSubjectRequestActionsCubit>().approve(
        request.id,
        approval,
      );
    }
  }

  void _onAction(BuildContext context, AdminSubjectRequestActionsState state) {
    if (state is AdminSubjectRequestActionFailure) {
      showCustomSnackBar(context, state.message, false);
      return;
    }
    if (state is! AdminSubjectRequestActionSuccess) return;
    final message = state.action == AdminSubjectRequestAction.approve
        ? S.of(context).adminSubjectRequestApproved
        : S.of(context).adminSubjectRequestRejectedSuccess;
    showCustomSnackBar(context, message, true);
  }
}
