import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmIssueIdealTeacherDialog extends StatefulWidget {
  const ConfirmIssueIdealTeacherDialog({super.key});

  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) => const ConfirmIssueIdealTeacherDialog(),
  );

  @override
  State<ConfirmIssueIdealTeacherDialog> createState() =>
      _ConfirmIssueIdealTeacherDialogState();
}

class _ConfirmIssueIdealTeacherDialogState
    extends State<ConfirmIssueIdealTeacherDialog> {
  late final TextEditingController _signerController;

  @override
  void initState() {
    super.initState();
    _signerController = TextEditingController(
      text: SessionManager.instance.userName ?? '',
    );
  }

  @override
  void dispose() {
    _signerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDialogHeader(title: s.confirmIssueIdealTeacherCertificate),
            const SizedBox(height: 12),
            Text(
              s.confirmIssueIdealTeacherMessage,
              textAlign: TextAlign.center,
              style: StylesManager.styleRegular14(context),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _signerController,
              label: isAr ? 'اسم المُوَقِّع' : 'Signer Name',
              hintText: isAr ? 'أدخل اسم الموقع...' : 'Enter signer name...',
              isRequired: true,
            ),
            const SizedBox(height: 20),
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
                      final signer = _signerController.text.trim();
                      if (signer.isNotEmpty) {
                        Navigator.pop(context, signer);
                      }
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
