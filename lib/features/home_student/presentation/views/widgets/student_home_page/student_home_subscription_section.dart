import 'package:bnan_app/features/dashboard/data/models/student_dashboard_subscription.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_subscriptions.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_state.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/widgets/student_subscriptions_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeSubscriptionSection extends StatelessWidget {
  const StudentHomeSubscriptionSection({
    super.key,
    required this.dashboardSubscription,
    required this.loading,
  });
  final DashboardSubscription? dashboardSubscription;
  final bool loading;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StudentSubscriptionsCubit, StudentSubscriptionsState>(
        builder: (context, state) {
          if (state is StudentSubscriptionsSuccess) {
            final private = state.student.subscriptions
                .where(
                  (item) =>
                      state.student.registrationMode == 'egyptian' &&
                      item.accessScope == 'single_subject' &&
                      item.packageType == 'hours',
                )
                .toList(growable: false);
            if (private.isNotEmpty) {
              return StudentHomeSubscriptions(
                student: state.student,
                subscriptions: private,
              );
            }
            if (state.student.registrationMode == 'egyptian' &&
                state.student.subscriptions.isEmpty &&
                dashboardSubscription?.isMonthly != true) {
              return const SizedBox.shrink();
            }
          }
          final fallback = PackageDetailsCard(
            subscription: dashboardSubscription,
            loading: loading,
          );
          if (state is! StudentSubscriptionsFailure) return fallback;
          return Column(
            children: [
              fallback,
              StudentSubscriptionsFailureView(
                message: state.message,
                onRetry: context.read<StudentSubscriptionsCubit>().loadHome,
              ),
            ],
          );
        },
      );
}
