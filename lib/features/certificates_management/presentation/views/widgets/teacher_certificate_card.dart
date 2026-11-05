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
  const TeacherCertificateCard({
    super.key,
    required this.certificate,
    this.isAdmin = false,
    this.onIssue,
    this.isIssuing = false,
  });
  final TeacherCertificateModel certificate;
  final bool isAdmin;
  final VoidCallback? onIssue;
  final bool isIssuing;

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
                const SizedBox(width: 8),
                CertificateActionButton(
                  title: S.of(context).preview,
                  onTap: () => _preview(context),
                ),
                if (isAdmin && certificate.isDraft && onIssue != null) ...[
                  const SizedBox(width: 8),
                  CertificateActionButton(
                    title: isIssuing
                        ? S.of(context).loading
                        : S.of(context).issueCertificate,
                    onTap: isIssuing ? null : onIssue,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _details(BuildContext context) {
    final displayName = certificate.recipientName.isNotEmpty
        ? certificate.recipientName
        : certificate.teacherName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold12(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
        if (certificate.recipientName.isNotEmpty &&
            certificate.teacherName.isNotEmpty &&
            certificate.recipientName != certificate.teacherName)
          Text(
            certificate.teacherName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: ColorManager.grey7D7D),
          ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            StatusBadge(text: _type(context)),
            StatusBadge(text: _statusText(context)),
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
  }

  String _statusText(BuildContext context) => switch (certificate.status) {
    'issued' => S.of(context).active,
    'revoked' => S.of(context).payrollCancelled,
    _ => S.of(context).payrollDraft,
  };

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
    final issuedAt = certificate.issuedAt ?? certificate.createdAt;
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
