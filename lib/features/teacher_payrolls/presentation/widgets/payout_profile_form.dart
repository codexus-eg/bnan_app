import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payout_method_selector.dart';

class PayoutProfileForm extends StatefulWidget {
  const PayoutProfileForm({
    super.key,
    this.teacherId,
    this.initial,
    this.selfService = false,
    this.popOnSuccess = true,
  }) : assert(selfService || teacherId != null);
  final String? teacherId;
  final PayoutProfileModel? initial;
  final bool selfService, popOnSuccess;
  @override
  State<PayoutProfileForm> createState() => _PayoutProfileFormState();
}

class _PayoutProfileFormState extends State<PayoutProfileForm> {
  final key = GlobalKey<FormState>();
  late PayoutMethod method = PayoutMethod.fromApi(widget.initial?.method ?? '');
  late final holder = TextEditingController(
        text: widget.initial?.accountHolderName,
      ),
      insta = TextEditingController(text: widget.initial?.instapayAddress),
      provider = TextEditingController(text: widget.initial?.walletProvider),
      phone = TextEditingController(text: widget.initial?.walletPhone),
      bank = TextEditingController(text: widget.initial?.bankName),
      account = TextEditingController(text: widget.initial?.accountNumber),
      iban = TextEditingController(text: widget.initial?.iban);
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<TeacherPayoutProfileCubit, TeacherPayoutProfileState>(
      listener: (context, state) {
        if (state is TeacherPayoutProfileSuccess && widget.popOnSuccess) {
          Navigator.pop(context, state.profile);
        }
      },
      child: Form(
        key: key,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PayoutMethodSelector(
                value: method,
                onChanged: (v) => setState(() {
                  method = v;
                  insta.clear();
                  provider.clear();
                  phone.clear();
                  bank.clear();
                  account.clear();
                  iban.clear();
                }),
              ),
              CustomTextField(
                label: s.payrollAccountHolder,
                controller: holder,
                isRequired: true,
                validator: _required,
              ),
              const SizedBox(height: 10),
              ..._methodFields(s),
              const SizedBox(height: 16),
              BlocBuilder<TeacherPayoutProfileCubit, TeacherPayoutProfileState>(
                builder: (context, state) => CustomAppButton(
                  text: s.saveChanges,
                  isLoading: state is TeacherPayoutProfileSaving,
                  onPressed: _save,
                ),
              ),
              if (context.watch<TeacherPayoutProfileCubit>().state
                  case TeacherPayoutProfileFailure(:final message))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _methodFields(S s) => switch (method) {
    PayoutMethod.instapay => [
      CustomTextField(
        label: s.payoutInstapayAddressLabel,
        controller: insta,
        isRequired: true,
        validator: _required,
      ),
    ],
    PayoutMethod.wallet => [
      CustomDropdownFormField(
        label: s.payrollWalletProvider,
        value: provider.text.isEmpty ? null : provider.text,
        items: const [
          'vodafone_cash',
          'orange_cash',
          'etisalat_cash',
          'we_pay',
          'other',
        ],
        itemsLabels: {
          'vodafone_cash': s.payoutVodafoneCash,
          'orange_cash': s.payoutOrangeCash,
          'etisalat_cash': s.payoutEtisalatCash,
          'we_pay': s.payoutWePay,
          'other': s.payoutOtherProvider,
        },
        onChanged: (value) => setState(() => provider.text = value ?? ''),
        isRequired: true,
        validator: _required,
      ),
      const SizedBox(height: 10),
      CustomTextField(
        label: s.payrollWalletPhone,
        controller: phone,
        isRequired: true,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s\-]')),
          LengthLimitingTextInputFormatter(16),
        ],
        validator: (value) =>
            PayoutProfileRequest.isValidWalletPhone(value ?? '')
            ? null
            : s.payoutWalletPhoneInvalid,
      ),
    ],
    _ => [
      CustomTextField(
        label: s.payrollBankName,
        controller: bank,
        isRequired: true,
        validator: _required,
      ),
      const SizedBox(height: 10),
      CustomTextField(label: s.payrollAccountNumber, controller: account),
      const SizedBox(height: 10),
      CustomTextField(
        label: s.payrollIban,
        controller: iban,
        validator: (_) =>
            account.text.trim().isEmpty && iban.text.trim().isEmpty
            ? s.payrollBankDestinationRequired
            : null,
      ),
    ],
  };
  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? S.current.fieldRequired : null;
  void _save() {
    if (key.currentState?.validate() != true) return;
    final request = PayoutProfileRequest(
      method: method,
      accountHolderName: holder.text,
      instapayAddress: insta.text,
      walletProvider: provider.text,
      walletPhone: phone.text,
      bankName: bank.text,
      accountNumber: account.text,
      iban: iban.text,
    );
    final cubit = context.read<TeacherPayoutProfileCubit>();
    widget.selfService
        ? cubit.saveMine(request)
        : cubit.save(widget.teacherId!, request);
  }

  @override
  void dispose() {
    for (final controller in [
      holder,
      insta,
      provider,
      phone,
      bank,
      account,
      iban,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }
}
