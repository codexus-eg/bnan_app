import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildrenPreviewCards extends StatelessWidget {
  const ParentChildrenPreviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetParentChildrenCubit, GetParentChildrenState>(
      builder: (_, state) {
        final isLoading =
            state is GetParentChildrenInitial ||
            state is GetParentChildrenLoading;
        final children = state is GetParentChildrenSuccess
            ? state.children.take(2).toList(growable: false)
            : isLoading
            ? parentChildrenSkeletonItems.take(2).toList(growable: false)
            : const <ParentChildModel>[];

        return AppSkeletonizer(
          isLoading: isLoading,
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                ParentChildCard(child: children[index]),
                if (index < children.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}
