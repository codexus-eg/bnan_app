import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_preview_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_action_button.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_image.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherCertificateCard extends StatelessWidget {
  const TeacherCertificateCard({super.key, required this.certificate});
  final TeacherCertificateModel certificate;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: CustomDetailsWidgetBackground(
      child: Column(
        children: [
          CertificateImage(imageUrl: certificate.previewImagePath),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: _details(context)),
                CertificateActionButton(
                  title: S.of(context).preview,
                  onTap: () => _preview(context),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _details(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        certificate.teacherName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: StylesManager.styleBold12(
          context,
        ).copyWith(color: ColorManager.greyA8AF),
      ),
      const SizedBox(height: 4),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          StatusBadge(text: _type(context)),
          if (_date(context).isNotEmpty)
            Text(
              _date(context),
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
        ],
      ),
    ],
  );

  String _type(BuildContext context) =>
      certificate.certificateType == 'ideal_teacher'
      ? S.of(context).idealTeacherCertificate
      : S.of(context).generalTeacherCertificate;

  String _date(BuildContext context) {
    final period = certificate.period;
    if (period?.month != null && period?.year != null) {
      return DateFormat.yMMMM(
        Localizations.localeOf(context).languageCode,
      ).format(DateTime(period!.year!, period.month!));
    }
    final issuedAt = certificate.issuedAt;
    return issuedAt == null
        ? ''
        : DateFormat.yMMMd(
            Localizations.localeOf(context).languageCode,
          ).format(issuedAt);
  }

  void _preview(BuildContext context) => showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha((255 * .72).round()),
    builder: (_) => CertificatePreviewDialog(
      imageUrl: certificate.previewImagePath,
      pdfUrl: certificate.pdfPath,
    ),
  );
}
