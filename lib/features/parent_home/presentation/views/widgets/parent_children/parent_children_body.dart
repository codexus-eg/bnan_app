import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_children/presentation/models/parent_add_child_args.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
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
          const SizedBox(height: 12),
          BlocBuilder<GetParentChildrenCubit, GetParentChildrenState>(
            builder: (context, state) => AddNewTopicButton(
              title: S.of(context).parentAddChild,
              path: ImageManager.plus,
              onTap: state is GetParentChildrenSuccess
                  ? () => _openAddChild(context, state.children)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
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

  Future<void> _openAddChild(
    BuildContext context,
    List<ParentChildModel> children,
  ) async {
    if (children.isEmpty) {
      showCustomSnackBar(context, S.of(context).noChildrenLinked, false);
      return;
    }
    final args = ParentAddChildArgs.fromChildren(children);
    if (args == null) {
      showCustomSnackBar(
        context,
        S.of(context).parentUnsupportedRegistrationMode,
        false,
      );
      return;
    }
    final result = await MyNavigator.goTo<ParentFlowResult>(
      context,
      Routes.parentAddChild,
      extra: args,
    );
    if (result == ParentFlowResult.completed && context.mounted) {
      context.read<GetParentChildrenCubit>().getParentChildren();
    }
  }
}
