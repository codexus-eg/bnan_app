import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayoutMethodSelector extends StatelessWidget {
  const PayoutMethodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final PayoutMethod value;
  final ValueChanged<PayoutMethod> onChanged;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final options = <PayoutMethod, String>{
      PayoutMethod.instapay: s.payrollInstapay,
      PayoutMethod.wallet: s.payrollWallet,
      PayoutMethod.bankAccount: s.payrollBankAccount,
    };
    return Column(
      children: options.entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onChanged(e.key),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: value == e.key
                        ? ColorManager.blueE3
                        : ColorManager.white,
                    border: Border.all(
                      color: value == e.key
                          ? ColorManager.mainColor15
                          : ColorManager.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    e.value,
                    style: StylesManager.styleBold14(context),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
