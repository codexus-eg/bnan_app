import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/teacher_payroll_card.dart';
import '../widgets/payroll_failure_view.dart';
import '../widgets/teacher_payroll_summary_card.dart';
import '../widgets/teacher_payrolls_skeleton.dart';
import '../widgets/teacher_payout_profile_card.dart';

class TeacherMyPayrollsBody extends StatefulWidget {
  const TeacherMyPayrollsBody({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<TeacherMyPayrollsBody> createState() => _TeacherMyPayrollsBodyState();
}

class _TeacherMyPayrollsBodyState extends State<TeacherMyPayrollsBody> {
  String? status;
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TeacherMyPayrollsCubit>();
    if (cubit.state is TeacherMyPayrollsLoading) cubit.load();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CustomAppbar(
        headerText: S.of(context).teacherMyEarnings,
        iconNeeded: widget.showBackButton,
      ),
      Expanded(
        child: BlocConsumer<TeacherMyPayrollsCubit, TeacherMyPayrollsState>(
          listener: (_, state) {
            if (state is TeacherMyPayrollsReady && state.message != null) {
              showCustomSnackBar(context, state.message!, false);
            }
          },
          builder: (_, state) {
            if (state is TeacherMyPayrollsLoading) {
              return const TeacherPayrollsSkeleton();
            }
            if (state is TeacherMyPayrollsFailure) {
              return PayrollFailureView(
                message: state.message,
                onRetry: () =>
                    context.read<TeacherMyPayrollsCubit>().load(status: status),
              );
            }
            final ready = state as TeacherMyPayrollsReady;
            return RefreshIndicator(
              onRefresh: () => context.read<TeacherMyPayrollsCubit>().load(
                status: status,
                refresh: true,
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...ready.data.summary.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TeacherPayrollSummaryCard(summary: e),
                    ),
                  ),
                  _filters(ready.updating),
                  const SizedBox(height: 12),
                  if (ready.data.payrolls.isEmpty) ...[
                    NoDataWidget(title: S.of(context).teacherPayrollEmpty),
                    const SizedBox(height: 24),
                  ] else
                    ...ready.data.payrolls.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TeacherPayrollCard(payroll: e),
                      ),
                    ),
                  TeacherPayoutProfileCard(profile: ready.profile),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );

  Widget _filters(bool updating) {
    final s = S.of(context);
    return Wrap(
      spacing: 8,
      children: [
        for (final option in <(String?, String)>[
          (null, s.teacherPayrollAll),
          ('draft', s.teacherPayrollUnderReview),
          ('paid', s.payrollPaid),
        ])
          ChoiceChip(
            label: Text(option.$2),
            selected: status == option.$1,
            onSelected: updating
                ? null
                : (_) {
                    setState(() => status = option.$1);
                    context.read<TeacherMyPayrollsCubit>().load(
                      status: option.$1,
                    );
                  },
          ),
      ],
    );
  }
}
