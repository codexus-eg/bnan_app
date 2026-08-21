import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_request_actions_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_request_actions_state.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_actions.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_details_dialog.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_info.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_labels.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestCard extends StatelessWidget {
  const AdminChangeRequestCard({super.key, required this.request});
  final ClassroomChangeRequestModel request;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<
        AdminChangeRequestActionsCubit,
        AdminChangeRequestActionsState
      >(
        listenWhen: (_, state) =>
            state is AdminChangeRequestActionFailure &&
                state.id == request.id ||
            state is AdminChangeRequestActionSuccess && state.id == request.id,
        listener: _listener,
        builder: (context, state) => InkWell(
          onTap: () => _showDetails(context),
          child: CustomDetailsWidgetBackground(
            child: Column(
              children: [
                CardHeader(
                  name: request.requesterName,
                  phone: '',
                  subtitle: changeRequestStatusLabel(
                    S.of(context),
                    request.status,
                  ),
                ),
                const SizedBox(height: 8),
                AdminChangeRequestInfo(request: request),
                if (_pending && !_completed(state)) ...[
                  const SizedBox(height: 8),
                  AdminChangeRequestActions(
                    requestId: request.id,
                    classroomSubjectId: request.classroomSubjectId,
                    navigateAfterApproval:
                        request.requestType == 'change_teacher',
                  ),
                ],
              ],
            ),
          ),
        ),
      );

  bool get _pending =>
      const {'pending', 'awaiting_admin_approval'}.contains(request.status);

  bool _completed(AdminChangeRequestActionsState state) =>
      state is AdminChangeRequestActionSuccess && state.id == request.id;

  Future<void> _showDetails(BuildContext context) async {
    final result = await context.read<AdminChangeRequestsCubit>().getDetails(
      request.id,
    );
    if (!context.mounted) return;
    result.fold(
      (failure) => showCustomSnackBar(context, failure.message, false),
      (details) => showDialog<void>(
        context: context,
        builder: (_) => AdminChangeRequestDetailsDialog(request: details),
      ),
    );
  }

  void _listener(BuildContext context, AdminChangeRequestActionsState state) {
    if (state is AdminChangeRequestActionFailure) {
      showCustomSnackBar(context, state.message, false);
    } else if (state is AdminChangeRequestActionSuccess) {
      showCustomSnackBar(
        context,
        state.action == AdminChangeRequestAction.approve
            ? S.of(context).changeRequestApprovedSuccess
            : S.of(context).changeRequestRejectedSuccess,
        true,
      );
    }
  }
}
