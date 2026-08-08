import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payrolls/teacher_payrolls_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payroll_failure_view.dart';
import 'payroll_list_card.dart';
import 'payroll_list_skeleton.dart';

class PayrollsContent extends StatelessWidget {
  const PayrollsContent({
    super.key,
    required this.from,
    required this.to,
    required this.reload,
  });
  final String from, to;
  final Future<void> Function() reload;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TeacherPayrollsCubit, TeacherPayrollsState>(
        builder: (context, state) {
          if (state is TeacherPayrollsFailure && state.previous.isEmpty) {
            return PayrollFailureView(message: state.message, onRetry: reload);
          }
          final loading =
              state is TeacherPayrollsInitial ||
              state is TeacherPayrollsLoading;
          final items = switch (state) {
            TeacherPayrollsSuccess(:final items) => items,
            TeacherPayrollsLoading(:final previous) => previous,
            TeacherPayrollsFailure(:final previous) => previous,
            _ => const [],
          };
          if (loading && items.isEmpty) {
            return const AppSkeletonizer(
              isLoading: true,
              child: PayrollListSkeleton(),
            );
          }
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 420,
                    child: NoDataWidget(
                      title: S.of(context).payrollNoMatchingTeachers,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: reload,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  PayrollListCard(item: items[i], from: from, to: to),
            ),
          );
        },
      );
}
