import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/download_icon_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentSubmissionFooter extends StatelessWidget {
  const StudentSubmissionFooter({
    super.key,
    required this.attachment,
    required this.buttonText,
    required this.onCorrectionPressed,
  });

  final String? attachment;
  final String? buttonText;
  final VoidCallback? onCorrectionPressed;

  @override
  Widget build(BuildContext context) {
    final attachmentValue = attachment;
    final hasAttachment = attachmentValue != null && attachmentValue.isNotEmpty;

    return Column(
      children: [
        if (hasAttachment) _attachment(context, attachmentValue),
        if (hasAttachment && buttonText != null) const SizedBox(height: 8),
        if (buttonText != null)
          SizedBox(
            height: 30,
            child: CustomAppButton(
              text: buttonText!,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.white),
              onPressed: onCorrectionPressed,
            ),
          ),
      ],
    );
  }

  Widget _attachment(BuildContext context, String attachment) {
    return Row(
      children: [
        SvgPicture.asset(ImageManager.teacherAssignmentPaperclipIcon),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _fileName(attachment),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ),
        DownloadIconButton(url: attachment, fileName: _fileName(attachment)),
      ],
    );
  }

  String _fileName(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.pathSegments.isEmpty) return value;
    final name = uri.pathSegments.last;
    return name.isEmpty ? value : Uri.decodeComponent(name);
  }
}
