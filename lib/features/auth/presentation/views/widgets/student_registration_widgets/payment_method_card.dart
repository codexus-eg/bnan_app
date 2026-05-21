import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyA8AF.withAlpha(90)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: ColorManager.mainColor14),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title),
              if (subtitle != null) Text(subtitle!),
            ],
          ),
        ],
      ),
    );
  }
}