import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
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
          child: Text(item.email, style: StylesManager.styleRegular12(context)),
        ),
        const SizedBox(height: 12),
        PayrollInfoRow(
          label: S.of(context).payrollGulfWork,
          value: item.gulfDuration,
        ),
        PayrollInfoRow(
          label: S.of(context).payrollEgyptianWork,
          value: '${item.egyptianSessions}',
        ),
        PayrollInfoRow(
          label: S.of(context).payrollCurriculumsCount,
          value: '${item.curriculumsCount}',
        ),
        if (item.excludedSessions > 0) ...[
          PayrollWarningCard(
            text: S.of(context).payrollExcludedSessions(item.excludedSessions),
          ),
          const SizedBox(height: 10),
        ],
        CustomAppButton(
          text: _action(context),
          onPressed: enabled ? () => MyNavigator.goTo(context, _path) : null,
        ),
      ],
    ),
  );
  String _action(BuildContext context) => item.status == 'unprepared'
      ? S.of(context).payrollCreate
      : item.status == 'draft'
      ? S.of(context).payrollContinueDraft
      : S.of(context).payrollViewDetails;
  String get _path => item.payrollId.isNotEmpty
      ? Routes.teacherPayrollDetailsPath(item.payrollId)
      : Uri(
          path: Routes.teacherPayrollCreatePath(item.teacherId),
          queryParameters: {'from': from, 'to': to},
        ).toString();
}
