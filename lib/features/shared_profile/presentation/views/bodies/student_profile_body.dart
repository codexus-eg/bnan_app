import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentProfileBody extends StatelessWidget {
  const StudentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSystemui(
      child: Stack(
        children: [
          const ProfileBlueBackground(),
          SafeArea(
            child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
              builder: (context, state) {
                if (state is StudentProfileStateFailure) {
                  return Center(child: Text(state.errorMessage));
                }

                final isLoading = state is StudentProfileStateLoading;
                final user = state is StudentProfileStateSuccess
                    ? state.loggedUser
                    : LoggedUserModel.placeholder();

                return AppSkeletonizer(
                  isLoading: isLoading,
                  child: ProfileLayout(
                    fullName: user.user.fullName,
                    email: user.user.email,
                    phone: user.parent?.phone ?? '',
                    roleLabel: user.user.role,
                    subtitle: _studentSubtitle(context, user),
                    onRefresh: () {
                      StudentProfileCubit.get(context).getLoggedUser();
                    },
                    onLogout: () async {
                      await StudentProfileCubit.get(context).logout();
                      if (!context.mounted) return;
                      MyNavigator.goToOffAll(context, Routes.logIn);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _studentSubtitle(BuildContext context, LoggedUserModel user) {
    final grade = user.grade?.name ?? S.of(context).studentProfileGrade;
    return '$grade\n${S.of(context).studentProfileClass}';
  }
}
