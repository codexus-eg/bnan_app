import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';

class PayoutProfileDetails extends StatelessWidget {
  const PayoutProfileDetails({super.key, required this.profile});
  final PayoutProfileModel profile;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        PayrollInfoRow(label: s.payrollPayoutMethod, value: _method(s)),
        PayrollInfoRow(
          label: s.payrollAccountHolder,
          value: profile.accountHolderName,
        ),
        if (profile.method == 'instapay')
          PayrollInfoRow(
            label: s.payrollInstapayAddress,
            value: profile.instapayAddress,
          ),
        if (profile.method == 'wallet') ...[
          PayrollInfoRow(
            label: s.payrollWalletProvider,
            value: profile.walletProvider,
          ),
          PayrollInfoRow(
            label: s.payrollWalletPhone,
            value: profile.walletPhone,
          ),
        ],
        if (profile.method == 'bank_account') ...[
          PayrollInfoRow(label: s.payrollBankName, value: profile.bankName),
          if (profile.accountNumber.isNotEmpty)
            PayrollInfoRow(
              label: s.payrollAccountNumber,
              value: profile.accountNumber,
            ),
          if (profile.iban.isNotEmpty)
            PayrollInfoRow(label: s.payrollIban, value: profile.iban),
        ],
      ],
    );
  }

  String _method(S s) => switch (profile.method) {
    'instapay' => s.payrollInstapay,
    'wallet' => s.payrollWallet,
    _ => s.payrollBankAccount,
  };
}
