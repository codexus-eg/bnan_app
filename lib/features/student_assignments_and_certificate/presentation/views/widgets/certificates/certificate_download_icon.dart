import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CertificateDownloadIcon extends StatelessWidget {
  const CertificateDownloadIcon({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(ImageManager.downloadIcon ,height: 20,width: 20,fit: BoxFit.contain,)
    );
  }
}