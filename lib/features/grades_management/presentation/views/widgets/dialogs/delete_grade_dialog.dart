import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_cubit.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteGradeDialog extends StatelessWidget {
  const DeleteGradeDialog({super.key, required this.gradeId});

  final String gradeId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<GradeActionsCubit, GradeActionsState>(
      listener: (context, state) {
        if (state is DeleteGradeSuccess) {
          Navigator.pop(context, true);
        }

        if (state is DeleteGradeFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(title: s.deleteGrade),
                const SizedBox(height: 16),
                Text(
                  s.deleteGradeConfirmation,
                  textAlign: TextAlign.center,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: s.delete,
                  backgroundColor: ColorManager.redBA,
                  isLoading: state is DeleteGradeLoading,
                  onPressed: () {
                    context.read<GradeActionsCubit>().deleteGrade(gradeId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}