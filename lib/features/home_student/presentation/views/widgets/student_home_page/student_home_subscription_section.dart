import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_subscriptions.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_state.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/widgets/student_subscriptions_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeSubscriptionSection extends StatelessWidget {
  const StudentHomeSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StudentSubscriptionsCubit, StudentSubscriptionsState>(
        builder: (context, state) {
          if (state is StudentSubscriptionsSuccess) {
            if (state.student.subscriptions.isEmpty) {
              return const SizedBox.shrink();
            }
            return StudentHomeSubscriptions(
              student: state.student,
              subscriptions: state.student.subscriptions,
            );
          }
          if (state is StudentSubscriptionsFailure) {
            return StudentSubscriptionsFailureView(
              message: state.message,
              onRetry: context.read<StudentSubscriptionsCubit>().loadHome,
            );
          }
          return const SizedBox.shrink();
        },
      );
}
