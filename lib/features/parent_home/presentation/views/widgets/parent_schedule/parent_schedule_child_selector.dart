import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleChildSelector extends StatelessWidget {
  const ParentScheduleChildSelector({super.key, required this.state});

  final GetParentChildrenSuccess state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: CustomDropdown(
        key: const Key('parentScheduleChildDropdown'),
        label: S.of(context).child,
        value: state.selectedChildId,
        items: state.children.map((child) => child.id).toList(growable: false),
        itemsLabels: {
          for (final child in state.children) child.id: child.fullName,
        },
        onChanged: (id) => id == null
            ? null
            : context.read<GetParentChildrenCubit>().selectChild(id),
        useDefaultIcon: true,
      ),
    );
  }
}
