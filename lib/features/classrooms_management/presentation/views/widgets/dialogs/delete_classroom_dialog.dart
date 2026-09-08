import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteClassroomDialog extends StatefulWidget {
  const DeleteClassroomDialog({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  final String classroomId;
  final String classroomName;

  @override
  State<DeleteClassroomDialog> createState() => _DeleteClassroomDialogState();
}

class _DeleteClassroomDialogState extends State<DeleteClassroomDialog> {
  final reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<ClassroomActionsCubit, ClassroomActionsState>(
      listener: (context, state) {
        if (state is DeleteClassroomSuccess) {
          Navigator.pop(context, true);
        }
        if (state is DeleteClassroomFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteClassroomLoading;
        return CustomAppDialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(title: s.deleteClassroom),
                const SizedBox(height: 16),
                Text(
                  '${s.deleteClassroomConfirmation}\n(${widget.classroomName})',
                  textAlign: TextAlign.center,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: s.deleteReasonOptional,
                  controller: reasonController,
                  backgroundColor: ColorManager.white,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomAppButton(
                        text: s.cancel,
                        backgroundColor: ColorManager.white,
                        borderColor: ColorManager.blueE3,
                        textColor: ColorManager.mainColor15,
                        onPressed: isLoading ? null : () => Navigator.pop(context, false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomAppButton(
                        text: s.delete,
                        backgroundColor: ColorManager.redBA,
                        isLoading: isLoading,
                        onPressed: () {
                          final reason = reasonController.text.trim();
                          context.read<ClassroomActionsCubit>().deleteClassroom(
                                widget.classroomId,
                                reason: reason.isEmpty ? null : reason,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
