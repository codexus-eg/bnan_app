import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateDeleteConfirmDialog extends StatelessWidget {
  const CertificateDeleteConfirmDialog({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    child: Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: S.of(context).deleteCertificate),
          const SizedBox(height: 16),
          Text(
            S.of(context).confirmDeleteCertificate,
            textAlign: TextAlign.center,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomAppButton(
                  text: S.of(context).cancel,
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: ColorManager.white,
                  borderColor: ColorManager.blueE3,
                  textColor: ColorManager.mainColor15,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomAppButton(
                  text: S.of(context).delete,
                  backgroundColor: ColorManager.redBA,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
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
