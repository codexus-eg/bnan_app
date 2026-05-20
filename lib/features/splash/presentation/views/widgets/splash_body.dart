import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.55,
        child: SvgPicture.asset(
          ImageManager.appLogoSvg,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}