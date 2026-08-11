import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payroll_details/teacher_payroll_report_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payroll_details/teacher_payroll_report_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/teacher_payroll_presenter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/payroll_failure_view.dart';
import '../widgets/payroll_section.dart';
import '../widgets/payroll_status_badge.dart';
import '../widgets/teacher_payroll_payment_card.dart';
import '../widgets/teacher_payroll_report_totals.dart';
import '../widgets/teacher_payroll_report_work_item.dart';
import '../widgets/teacher_payrolls_skeleton.dart';

class TeacherPayrollReportView extends StatefulWidget {
  const TeacherPayrollReportView({super.key, required this.payrollId});
  final String payrollId;
  @override
  State<TeacherPayrollReportView> createState() =>
      _TeacherPayrollReportViewState();
}

class _TeacherPayrollReportViewState extends State<TeacherPayrollReportView> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherPayrollReportCubit>().load(widget.payrollId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).teacherPayrollReport),
    body: BlocConsumer<TeacherPayrollReportCubit, TeacherPayrollReportState>(
      listener: (_, state) {
        if (state is TeacherPayrollReportFailure && state.notFound) {
          showCustomSnackBar(
            context,
            S.of(context).teacherPayrollUnavailable,
            false,
          );
          MyNavigator.goToOff(context, Routes.teacherHomePayrollsPath);
        }
      },
      builder: (_, state) {
        if (state is TeacherPayrollReportLoading) {
          return const TeacherPayrollsSkeleton(report: true);
        }
        if (state is TeacherPayrollReportFailure) {
          if (state.notFound) return const SizedBox.shrink();
          return PayrollFailureView(
            message: state.message,
            onRetry: () => context.read<TeacherPayrollReportCubit>().load(
              widget.payrollId,
            ),
          );
        }
        return _content((state as TeacherPayrollReportReady).payroll);
      },
    ),
  );

  Widget _content(TeacherPayrollModel payroll) {
    final s = S.of(context),
        month = TeacherPayrollPresenter.month(context, payroll.period);
    final title = month == null
        ? s.teacherPayrollReport
        : s.teacherPayrollReportTitle(
            month,
            DateTime.parse(payroll.period.from).year,
          );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PayrollSection(
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PayrollStatusBadge(
                status: payroll.status,
                displayLabel: payroll.status == 'draft'
                    ? s.teacherPayrollUnderReview
                    : null,
              ),
              const SizedBox(height: 8),
              Text(TeacherPayrollPresenter.range(context, payroll.period)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...payroll.workItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TeacherPayrollReportWorkItem(
              item: item,
              currency: payroll.currency,
            ),
          ),
        ),
        TeacherPayrollReportTotals(payroll: payroll),
        const SizedBox(height: 12),
        TeacherPayrollPaymentCard(payroll: payroll),
        const SizedBox(height: 24),
      ],
    );
  }
}
