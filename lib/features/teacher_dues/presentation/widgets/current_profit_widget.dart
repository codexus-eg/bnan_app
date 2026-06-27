import 'package:bnan_app/features/teacher_dues/presentation/widgets/dues_amount.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurrentProfitWidget extends StatelessWidget {
  const CurrentProfitWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DuesAmount(
          title: S.of(context).currentProfits,
          amount: '1900 ج.م',
        ),
        const Spacer(),
        DuesAmount(
          title: S.of(context).expected,
          amount: '3800 ج.م',
          alignEnd: true,
        ),
      ],
    );
  }
}
