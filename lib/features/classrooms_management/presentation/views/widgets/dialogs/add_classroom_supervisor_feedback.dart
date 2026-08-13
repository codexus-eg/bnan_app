import 'package:bnan_app/core/shared_widget/compact_action_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomSupervisorFeedback extends StatelessWidget {
  const AddClassroomSupervisorFeedback({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      children: [
        Text(
          message,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: Colors.red),
        ),
        CompactActionButton(
          title: S.of(context).retry,
          onTap: context.read<GetSupervisorsCubit>().getSupervisors,
        ),
      ],
    ),
  );
}
