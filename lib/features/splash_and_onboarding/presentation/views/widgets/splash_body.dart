import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.35,
        child: Image.asset(
          ImageManager.appLogoPng,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}