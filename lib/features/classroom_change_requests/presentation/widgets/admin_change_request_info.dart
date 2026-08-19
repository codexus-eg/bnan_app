import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_labels.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminChangeRequestInfo extends StatelessWidget {
  const AdminChangeRequestInfo({super.key, required this.request});
  final ClassroomChangeRequestModel request;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final date = request.createdAt == null
        ? '-'
        : AppPickers.formatDateOnly(request.createdAt!.toIso8601String());
    return Column(
      children: [
        ClassMetaRow(label: s.requester, value: request.requesterName),
        ClassMetaRow(
          label: s.requesterType,
          value: changeRequesterTypeLabel(s, request.requesterType),
        ),
        ClassMetaRow(label: s.classroom, value: request.classroomName),
        ClassMetaRow(label: s.subjects, value: request.subjectName),
        ClassMetaRow(
          label: s.requestType,
          value: changeRequestTypeLabel(s, request.requestType),
        ),
        ClassMetaRow(label: s.requestReason, value: request.notes),
        ClassMetaRow(
          label: s.status,
          value: changeRequestStatusLabel(s, request.status),
        ),
        ClassMetaRow(label: s.adminSubjectRequestRequestedAt, value: date),
      ],
    );
  }
}
