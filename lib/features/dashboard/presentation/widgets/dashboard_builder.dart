import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_state.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_failure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBuilder<T extends DashboardData> extends StatelessWidget {
  const DashboardBuilder({
    super.key,
    required this.skeleton,
    required this.builder,
  });
  final T skeleton;
  final Widget Function(BuildContext context, T data, bool loading) builder;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is DashboardRefreshFailure) {
            showCustomSnackBar(context, state.message, false);
          }
          if (state is DashboardSessionInvalid) AppLogout.perform(context);
        },
        builder: (context, state) {
          if (state is DashboardFailure) {
            return DashboardFailureView(
              message: state.message,
              onRetry: context.read<DashboardCubit>().load,
            );
          }
          final value = state is DashboardDataState && state.data is T
              ? state.data as T
              : skeleton;
          final loading =
              state is DashboardInitial || state is DashboardLoading;
          return builder(context, value, loading);
        },
      );
}
