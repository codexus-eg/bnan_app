import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          ImageManager.appLogoPng,
          height: 60,
          width: 53,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: StylesManager.styleBold20(context),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: subtitleStyle ?? StylesManager.styleBold12(context),
        ),
      ],
    );
  }
}
