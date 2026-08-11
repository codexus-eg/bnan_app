import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleChildSelector extends StatelessWidget {
  const ParentScheduleChildSelector({super.key, required this.state});

  final GetParentChildrenSuccess state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: ParentChildSelector(
        selectorKey: const Key('parentScheduleChildDropdown'),
        children: state.children
            .map(
              (child) =>
                  ParentChildSelectorItem(id: child.id, name: child.fullName),
            )
            .toList(),
        selectedChildId: state.selectedChildId,
        onChanged: context.read<GetParentChildrenCubit>().selectChild,
      ),
    );
  }
}
