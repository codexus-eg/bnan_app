import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
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
          child: CustomDeleteDialog(
            gradeId: gradeId,
            isLoading: state is DeleteGradeLoading,
            dialogHeader: S.of(context).deleteGrade,
            subtitle: S.of(context).deleteGradeConfirmation,
            onPressed: () {
              context.read<GradeActionsCubit>().deleteGrade(gradeId);
            },
          ),
        );
      },
    );
  }
}
