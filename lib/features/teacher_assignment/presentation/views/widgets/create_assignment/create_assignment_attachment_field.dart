import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAssignmentAttachmentField extends StatelessWidget {
  const CreateAssignmentAttachmentField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateAssignmentCubit>();

    return CustomTextField(
      label: S.of(context).attachmentFile,
      hintText: cubit.attachmentFileName ?? S.of(context).chooseFile,
      readOnly: true,
      onTap: cubit.pickAttachment,
      hintStyle: StylesManager.styleRegular16(
        context,
      ).copyWith(color: ColorManager.greyA8AF),
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8),
        child: SvgPicture.asset(
          ImageManager.teacherAssignmentPaperclipIcon,
          width: 16,
          height: 16,
        ),
      ),
    );
  }
}