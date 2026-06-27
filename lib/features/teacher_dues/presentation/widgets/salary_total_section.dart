import 'package:flutter/material.dart';

class SalaryTotalSection extends StatelessWidget {
  const SalaryTotalSection({
    super.key,
    required this.total,
    this.paidAt,
  });

  final String total;
  final String? paidAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'الصافي',
              style: TextStyle(
                color: Color(0xff102A56),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              total,
              style: const TextStyle(
                color: Color(0xff102A56),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (paidAt != null)
              Text(
                'تم الدفع في $paidAt',
                style: const TextStyle(
                  color: Color(0xffAEB6C4),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}