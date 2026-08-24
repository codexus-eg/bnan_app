import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_state.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/widgets/student_subscriptions_failure.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/widgets/student_subscriptions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubscriptionsBody extends StatelessWidget {
  const StudentSubscriptionsBody({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StudentSubscriptionsCubit, StudentSubscriptionsState>(
        builder: _build,
      );

  Widget _build(BuildContext context, StudentSubscriptionsState state) {
    if (state is StudentSubscriptionsFailure) {
      return StudentSubscriptionsFailureView(
        message: state.message,
        onRetry: context.read<StudentSubscriptionsCubit>().load,
      );
    }
    if (state is StudentSubscriptionsSuccess) {
      final cubit = context.read<StudentSubscriptionsCubit>();
      return StudentSubscriptionsList(
        student: state.student,
        onRefresh: cubit.load,
        isLocallyPending: cubit.isRenewalPending,
        onRenewalPending: cubit.markRenewalPending,
      );
    }
    return const AppSkeletonizer(
      isLoading: true,
      child: Center(child: NoDataWidget()),
    );
  }
}
