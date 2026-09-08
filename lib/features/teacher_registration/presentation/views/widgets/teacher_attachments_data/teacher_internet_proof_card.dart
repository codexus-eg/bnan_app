import 'dart:io';
import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_file_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherInternetProofCard extends StatelessWidget {
  const TeacherInternetProofCard({
    super.key,
    required this.file,
    required this.onTap,
  });

  final File? file;
  final VoidCallback onTap;

  static const String fastUrl = 'https://fast.com';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (file == null)
          TeacherUploadFileCard(
            title: S.of(context).stableInternetProof,
            file: null,
            onTap: onTap,
          )
        else
          InkWell(
            onTap: onTap,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    file!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(S.of(context).replaceStableInternetProof),
              ],
            ),
          ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => FileUrlLauncher.open(fastUrl),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.open_in_new,
                size: 16,
                color: ColorManager.mainColor14,
              ),
              const SizedBox(width: 6),
              Text(
                S.of(context).testInternetSpeed,
                style: StylesManager.styleMedium14(context).copyWith(
                  color: ColorManager.mainColor14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
