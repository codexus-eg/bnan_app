
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/certificate_model.dart';
import 'package:flutter/material.dart';

class CertificateInfo extends StatelessWidget {
  const CertificateInfo({super.key, required this.certificate});

  final CertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          certificate.title,
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
        Text(
          certificate.subtitle,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}