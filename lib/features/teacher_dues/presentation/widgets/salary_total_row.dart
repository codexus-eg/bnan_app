import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SalaryTotalRow extends StatelessWidget {
  const SalaryTotalRow({super.key, required this.isPaid});

  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isPaid ? 'تم الدفع في 05-02-2026' : '',
          style: const TextStyle(color: Color(0xffAEB6C4), fontSize: 12),
        ),
        const Spacer(),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الصافي', style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.mainColor14
            )),
            Text('2600 ج.م', style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.mainColor14
            )),
          ],
        ),
      ],
    );
  }
}