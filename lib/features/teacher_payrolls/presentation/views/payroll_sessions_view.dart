import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/sessions/payroll_sessions_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/sessions/payroll_sessions_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_failure_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_info_row.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayrollSessionsView extends StatefulWidget {
  const PayrollSessionsView({
    super.key,
    required this.teacherId,
    required this.curriculumId,
    required this.from,
    required this.to,
    required this.system,
  });
  final String teacherId, curriculumId, from, to, system;
  @override
  State<PayrollSessionsView> createState() => _PayrollSessionsViewState();
}

class _PayrollSessionsViewState extends State<PayrollSessionsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() => context.read<PayrollSessionsCubit>().load(
    teacherId: widget.teacherId,
    curriculumId: widget.curriculumId,
    from: widget.from,
    to: widget.to,
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).payrollSessionDetails),
    body: BlocBuilder<PayrollSessionsCubit, PayrollSessionsState>(
      builder: _build,
    ),
  );
  Widget _build(BuildContext context, PayrollSessionsState state) {
    if (state is PayrollSessionsFailure) {
      return PayrollFailureView(message: state.message, onRetry: _load);
    }
    if (state is! PayrollSessionsSuccess) {
      return const AppSkeletonizer(isLoading: true, child: SizedBox.expand());
    }
    if (state.details.sessions.isEmpty) return const NoDataWidget();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PayrollSection(
          title: S.of(context).payrollWorkSummary,
          child: Column(
            children: [
              PayrollInfoRow(
                label: S.of(context).payrollSessionsCount,
                value: '${state.details.sessionsCount}',
              ),
              if (widget.system == 'gulf')
                PayrollInfoRow(
                  label: S.of(context).payrollDuration,
                  value: state.details.displayDuration,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...state.details.sessions.map(
          (session) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PayrollSection(
              title: session.title,
              child: Column(
                children: [
                  PayrollInfoRow(
                    label: S.of(context).date,
                    value: session.date,
                  ),
                  PayrollInfoRow(
                    label: S.of(context).payrollStatus,
                    value: session.status,
                  ),
                  PayrollInfoRow(
                    label: S.of(context).payrollIncluded,
                    value: session.included
                        ? S.of(context).yes
                        : S.of(context).no,
                  ),
                  if (widget.system == 'gulf')
                    PayrollInfoRow(
                      label: S.of(context).payrollDurationMinutes,
                      value: '${session.durationMinutes}',
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
