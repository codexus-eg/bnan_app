import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_calculator.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_adjustments_section.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_currency_field.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_failure_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_payment_details.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_payout_section.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_read_only_adjustments.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_teacher_summary.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_totals_section.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_warning_card.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_work_item_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherPayrollDetailsView extends StatefulWidget {
  const TeacherPayrollDetailsView({
    super.key,
    this.payrollId,
    this.teacherId,
    this.from,
    this.to,
  });
  final String? payrollId, teacherId, from, to;
  @override
  State<TeacherPayrollDetailsView> createState() =>
      _TeacherPayrollDetailsViewState();
}

class _TeacherPayrollDetailsViewState extends State<TeacherPayrollDetailsView> {
  final formKey = GlobalKey<FormState>();
  final rates = <String, TextEditingController>{};
  final bonus = TextEditingController(),
      deduction = TextEditingController(),
      adjustment = TextEditingController(),
      notes = TextEditingController();
  String currency = 'EGP', hydrated = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final cubit = context.read<TeacherPayrollDetailsCubit>();
    widget.payrollId?.isNotEmpty == true
        ? cubit.loadPayroll(widget.payrollId!)
        : cubit.loadPreview(
            teacherId: widget.teacherId!,
            from: widget.from!,
            to: widget.to!,
          );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).teacherPayrolls),
    body: BlocConsumer<TeacherPayrollDetailsCubit, TeacherPayrollDetailsState>(
      listener: (_, state) {
        if (state is TeacherPayrollDetailsReady && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (state is TeacherPayrollDetailsFailure) {
          return PayrollFailureView(message: state.message, onRetry: _load);
        }
        if (state is! TeacherPayrollDetailsReady) {
          return const AppSkeletonizer(
            isLoading: true,
            child: SizedBox.expand(),
          );
        }
        _hydrate(state.payroll);
        return _content(state);
      },
    ),
  );
  Widget _content(TeacherPayrollDetailsReady state) {
    final p = state.payroll;
    final readOnly = p.status == 'paid' || p.status == 'cancelled';
    if (p.workItems.isEmpty) {
      return NoDataWidget(title: S.of(context).payrollNoWork);
    }
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PayrollTeacherSummary(payroll: p),
          const SizedBox(height: 12),
          if (p.excludedSessions > 0) ...[
            PayrollWarningCard(
              text: S.of(context).payrollExcludedSessions(p.excludedSessions),
            ),
            const SizedBox(height: 12),
          ],
          ...p.warnings.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PayrollWarningCard(text: w),
            ),
          ),
          ...p.workItems.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PayrollWorkItemCard(
                item: w,
                teacherId: p.teacher.id,
                from: p.period.from,
                to: p.period.to,
                controller: rates[w.gradeId]!,
                currency: currency,
                readOnly: readOnly,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          if (readOnly)
            PayrollReadOnlyAdjustments(payroll: p)
          else
            PayrollAdjustmentsSection(
              bonus: bonus,
              deduction: deduction,
              adjustmentNote: adjustment,
              notes: notes,
              onChanged: (_) => setState(() {}),
            ),
          const SizedBox(height: 12),
          if (!readOnly)
            PayrollCurrencyField(
              value: currency,
              onChanged: (v) => setState(() => currency = v ?? currency),
            ),
          const SizedBox(height: 12),
          PayrollTotalsSection(
            items: p.workItems,
            rates: {
              for (final e in rates.entries)
                e.key: double.tryParse(e.value.text) ?? 0,
            },
            bonus: double.tryParse(bonus.text) ?? p.bonus,
            deduction: double.tryParse(deduction.text) ?? p.deduction,
            currency: currency,
            backendTotal: readOnly ? p.totals.total : null,
          ),
          const SizedBox(height: 12),
          if (p.status == 'draft')
            PayrollPayoutSection(
              teacherId: p.teacher.id,
              profile: state.profile,
            ),
          if (p.payment != null) ...[
            const SizedBox(height: 12),
            PayrollPaymentDetails(payment: p.payment!),
          ],
          const SizedBox(height: 16),
          if (!readOnly)
            CustomAppButton(
              text: S.of(context).payrollSaveDraft,
              isLoading: state.saving,
              onPressed: _hasValidRates ? () => _save(p) : null,
            ),
          if (p.status == 'draft') ...[
            const SizedBox(height: 8),
            CustomAppButton(
              text: S.of(context).payrollConfirmPayment,
              onPressed: state.profile == null
                  ? null
                  : () => MyNavigator.goTo(
                      context,
                      Routes.teacherPayrollPaymentPath(p.id),
                    ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _hydrate(TeacherPayrollModel p) {
    final key = p.id.isEmpty ? '${p.teacher.id}:${p.period.from}' : p.id;
    if (hydrated == key) return;
    hydrated = key;
    currency = p.currency.isEmpty ? 'EGP' : p.currency;
    bonus.text = p.bonus == 0 ? '' : '${p.bonus}';
    deduction.text = p.deduction == 0 ? '' : '${p.deduction}';
    adjustment.text = p.adjustmentNote;
    notes.text = p.notes;
    for (final item in p.workItems) {
      rates[item.gradeId] = TextEditingController(
        text: item.hasRate ? '${item.rate}' : '',
      );
    }
  }

  void _save(TeacherPayrollModel p) {
    if (formKey.currentState?.validate() != true) return;
    final mapped = p.workItems
        .map(
          (w) => PayrollRateRequest(
            w.gradeId,
            double.parse(rates[w.gradeId]!.text),
          ),
        )
        .toList();
    final b = double.tryParse(bonus.text) ?? 0,
        d = double.tryParse(deduction.text) ?? 0;
    if (PayrollCalculator.total(
          p.workItems,
          {for (final r in mapped) r.gradeId: r.rate},
          b,
          d,
        ) <
        0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).payrollNegativeTotal)),
      );
      return;
    }
    context.read<TeacherPayrollDetailsCubit>().save(
      SavePayrollRequest(
        teacherId: p.id.isEmpty ? p.teacher.id : null,
        period: p.id.isEmpty ? p.period : null,
        currency: currency,
        rates: mapped,
        bonus: b,
        deduction: d,
        adjustmentNote: adjustment.text,
        notes: notes.text,
      ),
    );
  }

  bool get _hasValidRates =>
      rates.isNotEmpty &&
      rates.values.every((controller) {
        final rate = double.tryParse(controller.text.trim());
        return rate != null && rate >= 0;
      });
}
