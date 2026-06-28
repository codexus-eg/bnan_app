import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScheduleAttachmentField extends StatelessWidget {
  const ScheduleAttachmentField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: S.of(context).attachmentFile,
      hintText: S.of(context).chooseFile,
      readOnly: true,
      hintStyle: StylesManager.styleRegular16(context).copyWith(
        color: ColorManager.greyA8AF
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          ImageManager.teacherAssignmentPaperclipIcon,
          colorFilter: const ColorFilter.mode(
            ColorManager.greyA8AF,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
