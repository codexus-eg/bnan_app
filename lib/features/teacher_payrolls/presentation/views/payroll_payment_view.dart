import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payment_confirmation_dialog.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_failure_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_payment_details.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_payout_section.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_receipt_field.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_teacher_summary.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PayrollPaymentView extends StatefulWidget {
  const PayrollPaymentView({super.key, required this.payrollId});
  final String payrollId;
  @override
  State<PayrollPaymentView> createState() => _PayrollPaymentViewState();
}

class _PayrollPaymentViewState extends State<PayrollPaymentView> {
  final reference = TextEditingController(), notes = TextEditingController();
  DateTime? paidAt;
  String? receipt, receiptError;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<TeacherPayrollDetailsCubit>().loadPayroll(
        widget.payrollId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).payrollConfirmPayment),
    body: MultiBlocListener(
      listeners: [
        BlocListener<PayrollPaymentCubit, PayrollPaymentState>(
          listener: _paymentListener,
        ),
      ],
      child:
          BlocBuilder<TeacherPayrollDetailsCubit, TeacherPayrollDetailsState>(
            builder: (context, state) {
              if (state is TeacherPayrollDetailsFailure) {
                return PayrollFailureView(
                  message: state.message,
                  onRetry: () => context
                      .read<TeacherPayrollDetailsCubit>()
                      .loadPayroll(widget.payrollId),
                );
              }
              if (state is! TeacherPayrollDetailsReady) {
                return const AppSkeletonizer(
                  isLoading: true,
                  child: SizedBox.expand(),
                );
              }
              final p = state.payroll;
              if (p.status != 'draft') {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    PayrollTeacherSummary(payroll: p),
                    if (p.payment != null) ...[
                      const SizedBox(height: 12),
                      PayrollPaymentDetails(payment: p.payment!),
                    ],
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PayrollTeacherSummary(payroll: p),
                  const SizedBox(height: 12),
                  PayrollPayoutSection(
                    teacherId: p.teacher.id,
                    profile: state.profile,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: S.of(context).payrollPaidAt,
                    controller: TextEditingController(
                      text: paidAt == null
                          ? ''
                          : DateFormat('yyyy-MM-dd', 'en').format(paidAt!),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final value = await AppPickers.pickDate(
                        context: context,
                        firstDate: DateTime(2020),
                      );
                      if (value != null) setState(() => paidAt = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: S.of(context).payrollTransactionReference,
                    controller: reference,
                  ),
                  const SizedBox(height: 12),
                  PayrollReceiptField(
                    path: receipt,
                    error: receiptError,
                    onChanged: _receiptChanged,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: S.of(context).notes,
                    controller: notes,
                    maxLine: 3,
                  ),
                  const SizedBox(height: 18),
                  BlocBuilder<PayrollPaymentCubit, PayrollPaymentState>(
                    builder: (context, payment) => CustomAppButton(
                      text: S.of(context).payrollConfirmPayment,
                      isLoading: payment is PayrollPaymentLoading,
                      onPressed: state.profile == null
                          ? null
                          : () => _confirm(p.totals.total, p.currency),
                    ),
                  ),
                ],
              );
            },
          ),
    ),
  );
  void _receiptChanged(String? value) {
    if (value?.startsWith('error:') == true) {
      final code = value!.substring(6);
      setState(
        () => receiptError = code == 'size'
            ? S.of(context).payrollReceiptTooLarge
            : code == 'type'
            ? S.of(context).payrollReceiptInvalidType
            : S.of(context).payrollReceiptMissing,
      );
    } else {
      setState(() {
        receipt = value;
        receiptError = null;
      });
    }
  }

  Future<void> _confirm(double total, String currency) async {
    if (receipt == null) {
      setState(() => receiptError = S.of(context).payrollReceiptRequired);
      return;
    }
    if (!await showPaymentConfirmation(
          context,
          PayrollAmountFormatter.format(total),
          currency,
        ) ||
        !mounted) {
      return;
    }
    context.read<PayrollPaymentCubit>().pay(
      widget.payrollId,
      PayrollPaymentRequest(
        receiptPath: receipt!,
        paidAt: paidAt,
        transactionReference: reference.text,
        notes: notes.text,
      ),
    );
  }

  void _paymentListener(BuildContext context, PayrollPaymentState state) {
    if (state is PayrollPaymentSuccess) {
      context.read<TeacherPayrollDetailsCubit>().loadPayroll(widget.payrollId);
    }
    if (state is PayrollPaymentFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      if (state.code == 'PAYROLL_ALREADY_FINALIZED' ||
          state.code == 'PAYOUT_METHOD_MISMATCH') {
        context.read<TeacherPayrollDetailsCubit>().loadPayroll(
          widget.payrollId,
        );
      }
      if (state.code == 'PAYROLL_RECEIPT_REQUIRED') {
        setState(() => receiptError = state.message);
      }
      if (state.code == 'INVALID_UPLOAD_FILE_TYPE') {
        setState(() => receiptError = state.message);
      }
    }
  }
}
