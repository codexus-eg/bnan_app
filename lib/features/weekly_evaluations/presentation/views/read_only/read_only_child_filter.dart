import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyChildFilter extends StatelessWidget {
  const ReadOnlyChildFilter({super.key, required this.state});
  final ReadOnlyWeeklyEvaluationsState state;

  static Widget? fromState(ReadOnlyWeeklyEvaluationsState state) =>
      state.role == ReadOnlyEvaluationsRole.parent && state.children.isNotEmpty
      ? ReadOnlyChildFilter(state: state)
      : null;

  @override
  Widget build(BuildContext context) {
    if (state.children.length == 1) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          S
              .of(context)
              .weeklyEvaluationStudentTitle(state.children.first.fullName),
          key: const Key('readOnlySingleChild'),
          style: StylesManager.styleBold14(context),
        ),
      );
    }
    return CustomDropdown(
      key: const Key('readOnlyChildDropdown'),
      label: S.of(context).child,
      value: state.selectedChildId,
      items: state.children.map((child) => child.id).toList(growable: false),
      itemsLabels: {
        for (final child in state.children) child.id: child.fullName,
      },
      onChanged: (id) => id == null
          ? null
          : context.read<ReadOnlyWeeklyEvaluationsCubit>().selectChild(id),
      useDefaultIcon: true,
    );
  }
}
