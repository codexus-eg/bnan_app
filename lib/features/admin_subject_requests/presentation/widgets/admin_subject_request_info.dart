import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/info_text.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminSubjectRequestInfo extends StatelessWidget {
  const AdminSubjectRequestInfo({super.key, required this.request});
  final AdminSubjectRequestModel request;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final date = request.requestedAt == null
        ? '-'
        : AppPickers.formatDateOnly(request.requestedAt!.toIso8601String());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              ClassMetaRow(
                label: s.curriculum,
                value: request.curriculum ?? '-',
              ),
              ClassMetaRow(label: s.classes, value: request.grade ?? '-'),
              ClassMetaRow(label: s.subjects, value: request.subject ?? '-'),
              ClassMetaRow(
                label: s.packages,
                value: request.packageName ?? '-',
              ),
              if (request.price != null)
                ClassMetaRow(
                  label: s.packagePrice,
                  value: '${request.price} ${request.currency ?? ''}'.trim(),
                ),
              if (request.notes != null)
                ClassMetaRow(label: s.notesText, value: request.notes!),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: InfoText(label: s.adminSubjectRequestRequestedAt, value: date),
        ),
      ],
    );
  }
}
