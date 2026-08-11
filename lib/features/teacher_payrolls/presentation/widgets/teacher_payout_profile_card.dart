import 'package:flutter/material.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class TeacherPayoutProfileCard extends StatelessWidget {
  const TeacherPayoutProfileCard({super.key, this.profile});
  final PayoutProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context), p = profile;
    return PayrollSection(
      title: s.teacherPayrollPayoutDetails,
      child: p == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.teacherPayrollNoPayout),
                const SizedBox(height: 6),
                Text(s.teacherPayrollAddPayoutContact),
              ],
            )
          : Column(
              children: [
                PayrollInfoRow(
                  label: s.teacherPayrollMethod,
                  value: _method(s, p.method),
                ),
                if (p.accountHolderName.isNotEmpty)
                  PayrollInfoRow(
                    label: s.teacherPayrollAccountName,
                    value: p.accountHolderName,
                  ),
                ..._details(s, p),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(s.teacherPayrollContactAdmin),
                ),
              ],
            ),
    );
  }

  String _method(S s, String method) => switch (method) {
    'instapay' => s.payrollInstapay,
    'wallet' => s.payrollWallet,
    'bank' || 'bank_account' => s.payrollBankAccount,
    _ => method,
  };

  List<Widget> _details(S s, PayoutProfileModel p) => [
    for (final entry in <(String, String)>[
      (s.payrollInstapayAddress, p.instapayAddress),
      (s.payrollWalletProvider, p.walletProvider),
      (s.payrollWalletPhone, p.walletPhone),
      (s.payrollBankName, p.bankName),
      (s.payrollAccountNumber, p.accountNumber),
      (s.payrollIban, p.iban),
    ])
      if (entry.$2.isNotEmpty) PayrollInfoRow(label: entry.$1, value: entry.$2),
  ];
}
