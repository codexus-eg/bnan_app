import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/home_student/data/models/student_subscription_model.dart';
import 'package:bnan_app/features/home_student/presentation/manager/get_student_subscription/get_student_subscription_cubit.dart';
import 'package:bnan_app/features/home_student/presentation/manager/get_student_subscription/get_student_subscription_state.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PackageDetailsCard extends StatelessWidget {
  const PackageDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<GetStudentSubscriptionCubit>()..getStudentSubscription(),
      child:
          BlocBuilder<GetStudentSubscriptionCubit, GetStudentSubscriptionState>(
            builder: (context, state) {
              final isLoading = state is GetStudentSubscriptionLoading;

              final subscription = state is GetStudentSubscriptionSuccess
                  ? state.subscription
                  : StudentSubscriptionModel.placeholder();

              if (state is GetStudentSubscriptionFailure) {
                return const SizedBox.shrink();
              }

              return AppSkeletonizer(
                isLoading: isLoading,
                child: PackageDetailsCardContent(subscription: subscription),
              );
            },
          ),
    );
  }
}
