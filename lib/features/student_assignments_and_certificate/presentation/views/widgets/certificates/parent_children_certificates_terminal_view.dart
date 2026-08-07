import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget? parentChildrenCertificatesTerminalView(
  BuildContext context,
  GetParentChildrenState state,
) {
  final retry = context.read<GetParentChildrenCubit>().getParentChildren;
  if (state is GetParentChildrenUnauthorized) {
    return ParentChildrenFailure(
      message: S.of(context).errorUnauthorized,
      onRetry: retry,
    );
  }
  if (state is GetParentChildrenFailure) {
    return ParentChildrenFailure(message: state.errorMessage, onRetry: retry);
  }
  if (state is GetParentChildrenSuccess && state.children.isEmpty) {
    return NoDataWidget(title: S.of(context).noRegisteredChildren);
  }
  if (state is! GetParentChildrenSuccess) {
    return const AppSkeletonizer(isLoading: true, child: SizedBox.expand());
  }
  return null;
}
