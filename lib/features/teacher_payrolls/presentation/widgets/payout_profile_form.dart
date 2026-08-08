import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payout_method_selector.dart';

class PayoutProfileForm extends StatefulWidget {
  const PayoutProfileForm({super.key, required this.teacherId, this.initial});
  final String teacherId;
  final PayoutProfileModel? initial;
  @override
  State<PayoutProfileForm> createState() => _PayoutProfileFormState();
}

class _PayoutProfileFormState extends State<PayoutProfileForm> {
  final key = GlobalKey<FormState>();
  late String method = widget.initial?.method.isNotEmpty == true
      ? widget.initial!.method
      : 'instapay';
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
        if (state is TeacherPayoutProfileSuccess) {
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
    'instapay' => [
      CustomTextField(
        label: s.payrollInstapayAddress,
        controller: insta,
        isRequired: true,
        validator: _required,
      ),
    ],
    'wallet' => [
      CustomTextField(
        label: s.payrollWalletProvider,
        controller: provider,
        isRequired: true,
        validator: _required,
      ),
      const SizedBox(height: 10),
      CustomTextField(
        label: s.payrollWalletPhone,
        controller: phone,
        isRequired: true,
        validator: _required,
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
    context.read<TeacherPayoutProfileCubit>().save(
      widget.teacherId,
      PayoutProfileRequest(
        method: method,
        accountHolderName: holder.text,
        instapayAddress: insta.text,
        walletProvider: provider.text,
        walletPhone: phone.text,
        bankName: bank.text,
        accountNumber: account.text,
        iban: iban.text,
      ),
    );
  }
}
