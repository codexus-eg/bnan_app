import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DuesAmount extends StatelessWidget {
  const DuesAmount({
    super.key,
    required this.title,
    required this.amount,
    this.alignEnd = false,
  });

  final String title, amount;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: StylesManager.styleBold20(
            context,
          ).copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
