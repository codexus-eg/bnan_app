import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/student_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    : LoggedUserModel.placeholder(
                        fullName: SessionManager.instance.userName ?? '',
                        email: SessionManager.instance.userEmail ?? '',
                      );

                return AppSkeletonizer(
                  isLoading: isLoading,
                  child: ProfileLayout(
                    fullName: user.user.fullName.trim().isEmpty
                        ? CurrentUserUi.name(context)
                        : user.user.fullName,
                    email: user.user.email.trim().isEmpty
                        ? SessionManager.instance.userEmail ?? ''
                        : user.user.email,
                    phone: user.user.phone.trim().isEmpty
                        ? SessionManager.instance.userPhone ?? ''
                        : user.user.phone,
                    roleLabel: CurrentUserUi.role(context),
                    subtitle: _studentSubtitle(context, user),
                    extraWidget: StudentProfileDetails(user: user),
                    onRefresh: () {
                      StudentProfileCubit.get(context).getLoggedUser();
                    },
                    onLogout: () async {
                      await StudentProfileCubit.get(context).logout();
                      final destination =
                          await AppLogout.destinationAfterLogout();
                      if (!context.mounted) return;
                      MyNavigator.goToOffAll(context, destination);
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
    final grade = user.grade?.name.trim();
    if (grade?.isNotEmpty == true) return grade!;
    return CurrentUserUi.role(context);
  }
}
