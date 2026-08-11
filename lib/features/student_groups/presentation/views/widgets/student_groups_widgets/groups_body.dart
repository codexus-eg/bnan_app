import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_cubit.dart';
import 'package:bnan_app/features/student_groups/presentation/manager/get_my_enrollments/get_my_enrollments_state.dart';
import 'package:bnan_app/core/shared_widget/shared_group_header.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/group_listview.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsBody extends StatelessWidget {
  const GroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SharedGroupHeader(
          title: S.of(context).myGroups,
          path: Routes.requestLesson,
          badgeTitle: ImageManager.plusIcon,
          isIcon: true,
        ),
        Expanded(
          child: BlocBuilder<GetMyEnrollmentsCubit, GetMyEnrollmentsState>(
            builder: (context, state) {
              final isLoading = state is GetMyEnrollmentsLoading;

              if (state is GetMyEnrollmentsFailure) {
                return Center(child: Text(state.errorMessage));
              }

              final enrollments = state is GetMyEnrollmentsSuccess
                  ? state.enrollments
                  : StudentEnrollmentModel.placeholderList();

              final pendingEnrollments = enrollments
                  .where((item) => item.isPending)
                  .toList();

              final activeEnrollments = enrollments
                  .where((item) => item.isApproved)
                  .toList();

              return AppSkeletonizer(
                isLoading: isLoading,
                child: GroupsListView(
                  pendingEnrollments: pendingEnrollments,
                  activeEnrollments: activeEnrollments,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
