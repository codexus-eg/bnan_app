import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_children/presentation/models/parent_add_child_args.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildRouteGate extends StatelessWidget {
  const ParentAddChildRouteGate({
    super.key,
    required this.initialArgs,
    required this.builder,
  });

  final ParentAddChildArgs? initialArgs;
  final Widget Function(BuildContext, ParentAddChildArgs) builder;

  @override
  Widget build(BuildContext context) {
    final initial = initialArgs;
    if (initial != null) return builder(context, initial);
    return BlocBuilder<GetParentChildrenCubit, GetParentChildrenState>(
      builder: (context, state) {
        if (state is GetParentChildrenSuccess) {
          final args = ParentAddChildArgs.fromChildren(state.children);
          if (args != null) return builder(context, args);
          return _failure(
            context,
            S.of(context).parentUnsupportedRegistrationMode,
          );
        }
        if (state is GetParentChildrenFailure) {
          return _failure(context, state.errorMessage);
        }
        if (state is GetParentChildrenUnauthorized) {
          return _failure(context, S.of(context).errorUnknown);
        }
        return const AppSkeletonizer(
          isLoading: true,
          child: Center(child: NoDataWidget()),
        );
      },
    );
  }

  Widget _failure(BuildContext context, String message) =>
      ParentChildrenFailure(
        message: message,
        onRetry: context.read<GetParentChildrenCubit>().getParentChildren,
      );
}
