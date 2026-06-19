import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_certificates/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/dialogs/certificate_preview_dialog.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_action_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CertificateActions extends StatelessWidget {
  const CertificateActions({super.key, required this.certificate});

  final TeacherCertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                S.of(context).total,
                textAlign: TextAlign.center,
                style: StylesManager.styleBold12(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
              const SizedBox(height: 4),
              Text(
                '${certificate.totalScore} / ${certificate.maxScore}',
                textAlign: TextAlign.center,
                style: StylesManager.styleBold12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ],
          ),
          CertificateActionButton(
            title: S.of(context).preview,
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withAlpha((255*.72).round()),
                builder: (_) =>
                    CertificatePreviewDialog(imageUrl: certificate.imageUrl),
              );
            },
          ),
          CertificateActionButton(
            title: S.of(context).edit,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const CertificateDialog(isEdit: true),
              );
            },
          ),
          CertificateActionButton(title: S.of(context).send, onTap: () {}),
          SvgPicture.asset(ImageManager.trash),
        ],
      ),
    );
  }
}
