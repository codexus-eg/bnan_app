import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'excluded_sessions_sheet.dart';
import 'payroll_info_row.dart';
import 'payroll_status_badge.dart';
import 'payroll_warning_card.dart';

class PayrollListCard extends StatelessWidget {
  const PayrollListCard({
    super.key,
    required this.item,
    required this.from,
    required this.to,
    this.enabled = true,
  });

  final PayrollListItemModel item;
  final String from, to;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.fullName,
                  maxLines: 2,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: Colors.black),
                ),
              ),
              PayrollStatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child:
                Text(item.email, style: StylesManager.styleRegular12(context)),
          ),
          const SizedBox(height: 12),
          PayrollInfoRow(
            label: s.payrollGeneralHours,
            value: item.generalDuration,
          ),
          PayrollInfoRow(
            label: s.payrollCourseHours,
            value: item.courseDuration,
          ),
          PayrollInfoRow(
            label: s.payrollTotalDuration,
            value: item.totalDuration,
          ),
          if (item.excludedSessionsCount > 0) ...[
            InkWell(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => ExcludedSessionsSheet(
                  sessions: item.excludedSessionsList,
                ),
              ),
              child: PayrollWarningCard(
                text: s.payrollExcludedSessions(item.excludedSessionsCount),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (item.hasOverlap) ...[
            PayrollWarningCard(
              text:
                  '${s.payrollOverlappingStatement}: ${_statusName(item.overlappingStatementStatus, s)}',
            ),
            const SizedBox(height: 10),
          ],
          CustomAppButton(
            text: _actionText(s),
            onPressed: enabled ? () => MyNavigator.goTo(context, _path) : null,
          ),
        ],
      ),
    );
  }

  String _actionText(S s) {
    if (item.hasOverlap) return s.payrollViewExistingStatement;
    if (item.status == 'unprepared') return s.payrollCreate;
    if (item.status == 'draft') return s.payrollContinueDraft;
    return s.payrollViewDetails;
  }

  String get _path {
    if (item.hasOverlap && item.overlappingStatementId != null) {
      return Routes.teacherPayrollDetailsPath(item.overlappingStatementId!);
    }
    if (item.payrollId.isNotEmpty) {
      return Routes.teacherPayrollDetailsPath(item.payrollId);
    }
    return Uri(
      path: Routes.teacherPayrollCreatePath(item.teacherId),
      queryParameters: {
        'from': from,
        'to': to,
        if (item.curriculumId.isNotEmpty) 'curriculumId': item.curriculumId,
      },
    ).toString();
  }

  String _statusName(String? status, S s) => switch (status) {
    'draft' => s.payrollDraft,
    'sent' => s.payrollSent,
    'payment_pending' => s.payrollPaymentPending,
    'paid' => s.payrollPaid,
    'cancelled' => s.payrollCancelled,
    _ => status ?? '',
  };
}
