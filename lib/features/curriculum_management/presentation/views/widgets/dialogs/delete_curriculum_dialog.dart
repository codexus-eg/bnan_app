import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_state.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteCurriculumDialog extends StatelessWidget {
  const DeleteCurriculumDialog({super.key, required this.curriculumId});

  final String curriculumId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurriculumActionsCubit, CurriculumActionsState>(
      listener: (context, state) {
        if (state is DeleteCurriculumFailure) {
          showCustomSnackBar(context, state.message, false);
        }
        if (state is DeleteCurriculumSuccess) {
          context.read<GetCurriculumsCubit>().removeCurriculum(
            state.curriculumId,
          );
          showCustomSnackBar(
            context,
            S.of(context).curriculumDeletedSuccessfully,
            true,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) => CustomAppDialog(
        child: CustomDeleteDialog(
          gradeId: curriculumId,
          isLoading: state is DeleteCurriculumLoading,
          showCancelButton: true,
          dialogHeader: S.of(context).deleteCurriculum,
          subtitle: S.of(context).deleteCurriculumConfirmation,
          onPressed: state is DeleteCurriculumLoading
              ? null
              : () => context.read<CurriculumActionsCubit>().deleteCurriculum(
                  curriculumId,
                ),
        ),
      ),
    );
  }
}
