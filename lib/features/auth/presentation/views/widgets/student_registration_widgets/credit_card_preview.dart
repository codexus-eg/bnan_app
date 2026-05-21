import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CreditCardPreview extends StatelessWidget {
  const CreditCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff403078),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FYI BANK', style: TextStyle(color: ColorManager.white)),
          Spacer(),
          Text('0000 2363 8364 8269', style: TextStyle(color: ColorManager.white)),
          SizedBox(height: 12),
          Text('Okechukwu ozioma', style: TextStyle(color: ColorManager.white)),
        ],
      ),
    );
  }
}