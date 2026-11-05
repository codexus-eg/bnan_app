import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificateIssueConfirmDialog extends StatelessWidget {
  const TeacherCertificateIssueConfirmDialog({
    super.key,
    required this.certificate,
  });

  final TeacherCertificateModel certificate;

  static void show(BuildContext context, TeacherCertificateModel certificate) {
    final cubit = context.read<TeacherCertificatesCubit>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: TeacherCertificateIssueConfirmDialog(certificate: certificate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final displayName = certificate.recipientName.isNotEmpty
        ? certificate.recipientName
        : certificate.teacherName;
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.issueCertificate),
            const SizedBox(height: 16),
            Text(
              displayName,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold14(context),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    text: s.cancel,
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: ColorManager.white,
                    borderColor: ColorManager.blueE3,
                    textColor: ColorManager.mainColor15,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    text: s.confirm,
                    onPressed: () {
                      Navigator.pop(context);
                      context
                          .read<TeacherCertificatesCubit>()
                          .issueCertificate(certificate.id);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
