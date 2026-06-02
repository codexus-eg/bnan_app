import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CertificateIconBox extends StatelessWidget {
  const CertificateIconBox({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(13),
      decoration: BoxDecoration(
        color: ColorManager.blueE3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            ColorManager.mainColor14,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}