import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: ColorManager.orangeE6,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorManager.blueE3
        )
      ),
      child: Text(
        text,
        style: StylesManager.styleRegular10(context).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
