import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminChangeRequestDetailsDialog extends StatelessWidget {
  const AdminChangeRequestDetailsDialog({super.key, required this.request});
  final ClassroomChangeRequestModel request;

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    width: 420,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: S.of(context).cancellationRequests),
          const SizedBox(height: 16),
          AdminChangeRequestInfo(request: request),
        ],
      ),
    ),
  );
}
