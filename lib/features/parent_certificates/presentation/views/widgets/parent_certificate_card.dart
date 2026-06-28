import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_certificates/data/models/parent_certificate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentCertificateCard extends StatelessWidget {
  const ParentCertificateCard({super.key, required this.certificate});

  final ParentCertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:  BorderRadius.circular(10),
            child: Image.asset(
              certificate.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.title,
                        style: StylesManager.styleBold16(
                          context,
                        ).copyWith(color: ColorManager.mainColor14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${certificate.studentName} - ${certificate.grade}',
                        style: StylesManager.styleRegular12(
                          context,
                        ).copyWith(color: ColorManager.greyA8AF),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        certificate.teacherName,
                        style: StylesManager.styleRegular12(
                          context,
                        ).copyWith(color: ColorManager.greyA8AF),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  ImageManager.downloadIcon,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    ColorManager.mainColor14,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
