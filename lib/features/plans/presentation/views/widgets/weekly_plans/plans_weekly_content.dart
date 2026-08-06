import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_state.dart';
import 'package:bnan_app/features/plans/presentation/mappers/weekly_plans_ui_mapper.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_classrooms_feedback.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_card.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_skeleton.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansWeeklyContent extends StatefulWidget {
  const PlansWeeklyContent({
    super.key,
    required this.classroom,
    required this.week,
    required this.showEmpty,
    this.waitingMessage,
    this.externalResponse,
    this.externalLoading = false,
    this.titleOverride,
  });

  final PlanClassroomOption? classroom;
  final int? week;
  final bool showEmpty;
  final String? waitingMessage;
  final WeeklyPlansResponseModel? externalResponse;
  final bool externalLoading;
  final String? titleOverride;

  @override
  State<PlansWeeklyContent> createState() => _PlansWeeklyContentState();
}

class _PlansWeeklyContentState extends State<PlansWeeklyContent> {
  WeeklyPlanUiModel? _lastPlan;

  @override
  void didUpdateWidget(covariant PlansWeeklyContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classroom?.id != widget.classroom?.id ||
        oldWidget.week != widget.week) {
      _lastPlan = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.externalResponse != null) {
      return _response(context, widget.externalResponse!);
    }
    if (widget.externalLoading) {
      return _table(context, _placeholder(context), loading: true);
    }
    if (widget.classroom == null || widget.week == null) {
      final loading = widget.waitingMessage == null;
      return _table(
        context,
        _placeholder(context, loading: loading),
        loading: loading,
      );
    }
    return BlocBuilder<GetWeeklyPlansCubit, GetWeeklyPlansState>(
      builder: (context, state) => switch (state) {
        GetWeeklyPlansSuccess() => _success(context, state),
        GetWeeklyPlansEmpty() => NoDataWidget(
          title: S.of(context).noPlansAvailable,
        ),
        GetWeeklyPlansFailure() => _failure(context, state),
        _ => _table(context, _lastPlan ?? _placeholder(context), loading: true),
      },
    );
  }

  Widget _success(BuildContext context, GetWeeklyPlansSuccess state) {
    return _response(context, state.response);
  }

  Widget _response(BuildContext context, WeeklyPlansResponseModel response) {
    final mapped = mapWeeklyPlansToUiModel(
      S.of(context),
      response,
      fallbackClassroomName: widget.classroom?.name ?? '',
      fallbackWeek: widget.week ?? 1,
      titleOverride: widget.titleOverride,
    );
    final empty = widget.showEmpty || isWeeklyPlansEmpty(response);
    final plan = empty && mapped.subjectNames.isEmpty
        ? _placeholder(context, loading: false)
        : empty && widget.showEmpty
        ? _placeholder(
            context,
            loading: false,
            subjectNames: mapped.subjectNames,
          )
        : mapped;
    _lastPlan = plan;
    return _table(context, plan);
  }

  Widget _failure(BuildContext context, GetWeeklyPlansFailure state) {
    return Column(
      children: [
        PlansClassroomsFeedback(
          message: state.message,
          onRetry: () => context.read<GetWeeklyPlansCubit>().getPlansByWeek(
            classroomId: widget.classroom!.id,
            week: widget.week!,
          ),
        ),
        const SizedBox(height: 8),
        _table(context, _lastPlan ?? _placeholder(context, loading: false)),
      ],
    );
  }

  WeeklyPlanUiModel _placeholder(
    BuildContext context, {
    bool loading = true,
    List<String>? subjectNames,
  }) {
    final s = S.of(context);
    final title = widget.classroom == null
        ? s.selectClassroomFirst
        : '${s.studyPlanTitlePrefix} ${widget.classroom!.name}';
    return WeeklyPlanSkeleton.create(
      s,
      title: title,
      subjectNames: subjectNames,
      loading: loading,
    );
  }

  Widget _table(
    BuildContext context,
    WeeklyPlanUiModel plan, {
    bool loading = false,
  }) {
    final table = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plan.title, style: StylesManager.styleBold14(context)),
        const SizedBox(height: 8),
        WeeklyPlanCard(plan: plan),
      ],
    );
    return loading ? AppSkeletonizer(isLoading: true, child: table) : table;
  }
}
