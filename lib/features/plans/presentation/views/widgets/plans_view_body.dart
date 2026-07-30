import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/mock/plans_mock_data.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialogs.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_filters_section.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_header_actions.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plan_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansViewBody extends StatefulWidget {
  const PlansViewBody({
    super.key,
    required this.policy,
    required this.showEmpty,
  });

  final PlansAccessPolicy policy;
  final bool showEmpty;

  @override
  State<PlansViewBody> createState() => _PlansViewBodyState();
}

class _PlansViewBodyState extends State<PlansViewBody> {
  late WeeklyPlanUiModel plan;
  String? classroom = 'first';
  String? week = 'week1';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    plan = PlansMockData.create(S.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      children: [
        if (widget.policy.showManagementActions) ...[
          PlansHeaderActions(
            policy: widget.policy,
            onAdd: () => PlansDialogs.showAdd(context, widget.policy),
            onUpload: () => PlansDialogs.showUpload(context, widget.policy),
          ),
          const SizedBox(height: 16),
        ],
        PlansFiltersSection(
          policy: widget.policy,
          classroom: classroom,
          week: week,
          onClassroomChanged: (value) => setState(() => classroom = value),
          onWeekChanged: (value) => setState(() => week = value),
        ),
        const SizedBox(height: 16),
        Text(plan.title, style: StylesManager.styleBold14(context)),
        const SizedBox(height: 8),
        if (widget.showEmpty)
          SizedBox(
            height: 260,
            child: NoDataWidget(title: S.of(context).noPlansForWeek),
          )
        else
          WeeklyPlanCard(plan: plan),
      ],
    );
  }
}
