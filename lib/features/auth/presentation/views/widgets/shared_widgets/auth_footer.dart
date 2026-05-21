import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return  Text(
      '© 2026 أكاديمية بنان - جميع الحقوق محفوظة',
      textAlign: TextAlign.center,
      style: StylesManager.styleBold12(context)
    );
  }
}