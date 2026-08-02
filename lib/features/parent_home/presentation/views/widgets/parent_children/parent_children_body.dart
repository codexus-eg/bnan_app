import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_failure.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildrenBody extends StatelessWidget {
  const ParentChildrenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(
            headerText: S.of(context).parentYourChildren,
            iconNeeded: false,
          ),
          Expanded(
            child: BlocBuilder<GetParentChildrenCubit, GetParentChildrenState>(
              builder: (context, state) {
                if (state is GetParentChildrenFailure) {
                  return ParentChildrenFailure(
                    message: state.errorMessage,
                    onRetry: context
                        .read<GetParentChildrenCubit>()
                        .getParentChildren,
                  );
                }
                if (state is GetParentChildrenSuccess) {
                  if (state.children.isEmpty) {
                    return NoDataWidget(title: S.of(context).noChildrenLinked);
                  }
                  return ParentChildrenList(children: state.children);
                }
                return const AppSkeletonizer(
                  isLoading: true,
                  child: ParentChildrenList(
                    children: parentChildrenSkeletonItems,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
