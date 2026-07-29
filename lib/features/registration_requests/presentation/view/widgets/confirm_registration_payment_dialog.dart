import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/features/registration_requests/data/models/confirm_registration_payment_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_state.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_payment_dialog_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmRegistrationPaymentDialog extends StatefulWidget {
  const ConfirmRegistrationPaymentDialog({super.key, required this.studentId});

  final String studentId;

  @override
  State<ConfirmRegistrationPaymentDialog> createState() =>
      _ConfirmRegistrationPaymentDialogState();
}

class _ConfirmRegistrationPaymentDialogState
    extends State<ConfirmRegistrationPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMethod = 'cash';
  File? _receipt;
  String? _receiptError;
  String? _submissionError;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      RegistrationRequestActionsCubit,
      RegistrationRequestActionsState
    >(
      listenWhen: (_, state) => _isCurrentPaymentAction(state),
      listener: _onActionState,
      builder: (context, _) {
        final isLoading = context
            .read<RegistrationRequestActionsCubit>()
            .isActionLoading(
              studentId: widget.studentId,
              actionType: RegistrationRequestActionType.confirmPayment,
            );
        return RegistrationPaymentDialogContent(
          formKey: _formKey,
          amountController: _amountController,
          notesController: _notesController,
          paymentMethod: _paymentMethod,
          receiptName: _receipt?.path.split(Platform.pathSeparator).last,
          receiptError: _receiptError,
          submissionError: _submissionError,
          isLoading: isLoading,
          onPaymentMethodChanged: (value) {
            if (value != null) setState(() => _paymentMethod = value);
          },
          onPickReceipt: isLoading ? null : _pickReceipt,
          onSubmit: isLoading ? null : _submit,
        );
      },
    );
  }

  bool _isCurrentPaymentAction(RegistrationRequestActionsState state) {
    return switch (state) {
      RegistrationRequestActionLoading(:final studentId, :final actionType) ||
      RegistrationRequestActionSuccess(:final studentId, :final actionType) ||
      RegistrationRequestActionFailure(:final studentId, :final actionType) =>
        studentId == widget.studentId &&
            actionType == RegistrationRequestActionType.confirmPayment,
      _ => false,
    };
  }

  void _onActionState(
    BuildContext context,
    RegistrationRequestActionsState state,
  ) {
    if (state is RegistrationRequestActionSuccess) {
      Navigator.of(context).pop(true);
    } else if (state is RegistrationRequestActionFailure) {
      setState(() => _submissionError = state.errorMessage);
    }
  }

  Future<void> _pickReceipt() async {
    final file = await FilePickerHelper.pickFile();
    if (file == null || !mounted) return;
    setState(() {
      _receipt = file;
      _receiptError = null;
    });
  }

  void _submit() {
    final cubit = context.read<RegistrationRequestActionsCubit>();
    if (cubit.isActionLoading(
      studentId: widget.studentId,
      actionType: RegistrationRequestActionType.confirmPayment,
    )) {
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_receipt == null) {
      setState(() => _receiptError = S.of(context).paymentReceiptRequired);
      return;
    }
    setState(() => _submissionError = null);
    cubit.confirmPayment(
      studentId: widget.studentId,
      request: ConfirmRegistrationPaymentRequestModel(
        amount: num.parse(_amountController.text.trim()),
        method: _paymentMethod,
        receiptImagePath: _receipt!.path,
        notes: _notesController.text,
      ),
    );
  }
}
