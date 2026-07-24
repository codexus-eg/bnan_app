import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/delete_egyptian_schedule_cubit/delete_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/delete_egyptian_schedule_cubit/delete_egyptian_schedule_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteEgyptianScheduleDialog extends StatelessWidget {
  const DeleteEgyptianScheduleDialog({super.key, required this.scheduleId});

  final String scheduleId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<
      DeleteEgyptianScheduleCubit,
      DeleteEgyptianScheduleState
    >(
      listener: (context, state) {
        if (state is DeleteEgyptianScheduleSuccess) {
          Navigator.pop(context, true);
        }

        if (state is DeleteEgyptianScheduleFailure) {
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
                CustomDialogHeader(title: s.deleteSchedule),
                const SizedBox(height: 16),
                Text(
                  s.deleteScheduleConfirmation,
                  textAlign: TextAlign.center,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: s.delete,
                  backgroundColor: ColorManager.redBA,
                  isLoading: state is DeleteEgyptianScheduleLoading,
                  onPressed: () {
                    context
                        .read<DeleteEgyptianScheduleCubit>()
                        .deleteEgyptianSchedule(scheduleId);
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
