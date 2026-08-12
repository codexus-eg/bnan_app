import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorClassroomDropdown extends StatelessWidget {
  const SupervisorClassroomDropdown({
    super.key,
    required this.selectedId,
    required this.onChanged,
    this.includeAll = false,
    this.backgroundColor,
  });

  static const allValue = '__all_classrooms__';
  final String? selectedId;
  final ValueChanged<SupervisorClassroomModel?> onChanged;
  final bool includeAll;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetSupervisorClassroomsCubit,
      GetSupervisorClassroomsState
    >(
      builder: (context, state) {
        final loading = state is GetSupervisorClassroomsLoading;
        final classrooms = state is GetSupervisorClassroomsSuccess
            ? state.response.data.where((item) => item.id.isNotEmpty).toList()
            : <SupervisorClassroomModel>[];
        final byId = {for (final item in classrooms) item.id: item};
        return CustomDropdown(
          label: includeAll
              ? S.of(context).selectClassroom
              : S.of(context).classRoom,
          hint: state is GetSupervisorClassroomsFailure
              ? state.errorMessage
              : loading
              ? S.of(context).loadingClassrooms
              : S.of(context).selectClassroom,
          value: includeAll && selectedId == null ? allValue : selectedId,
          items: loading ? null : [if (includeAll) allValue, ...byId.keys],
          itemsLabels: {
            if (includeAll) allValue: S.of(context).allClassrooms,
            for (final entry in byId.entries) entry.key: entry.value.name,
          },
          backgroundColor: backgroundColor,
          onChanged: (value) =>
              onChanged(value == allValue ? null : byId[value]),
        );
      },
    );
  }
}
