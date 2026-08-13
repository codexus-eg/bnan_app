import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_supervisor_dropdown.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_supervisor_feedback.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomSupervisorField extends StatelessWidget {
  const AddClassroomSupervisorField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetSupervisorsCubit, GetSupervisorsState>(
        builder: (context, state) {
          final supervisors = state is GetSupervisorsSuccess
              ? state.supervisors
              : const <SupervisorModel>[];
          final loading =
              state is GetSupervisorsLoading || state is GetSupervisorsInitial;
          final s = S.of(context);
          final hint = loading
              ? s.loading
              : supervisors.isEmpty
              ? s.noSupervisorsFound
              : s.supervisor;
          return Column(
            children: [
              AddClassroomSupervisorDropdown(
                value: value,
                hint: hint,
                supervisors: loading ? const [] : supervisors,
                onChanged: onChanged,
              ),
              if (state is GetSupervisorsFailure)
                AddClassroomSupervisorFeedback(message: state.errorMessage),
            ],
          );
        },
      );
}
