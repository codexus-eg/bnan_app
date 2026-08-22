import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/student_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileCubit, StudentProfileState>(
      builder: (context, state) {
        final bool isLoading = state is StudentProfileStateLoading;

        final loggedUser = state is StudentProfileStateSuccess
            ? state.loggedUser
            : LoggedUserModel.placeholder(
                fullName: SessionManager.instance.userName ?? '',
                email: SessionManager.instance.userEmail ?? '',
              );

        if (state is StudentProfileStateFailure) {
          return Center(child: Text(state.errorMessage));
        }

        return AppSkeletonizer(
          isLoading: isLoading,
          child: ProfileLayout(
            fullName: loggedUser.user.fullName.trim().isEmpty
                ? CurrentUserUi.name(context)
                : loggedUser.user.fullName,
            email: loggedUser.user.email,
            phone: loggedUser.user.phone,
            roleLabel: CurrentUserUi.role(context),
            subtitle: _studentSubtitle(context, loggedUser),
            extraWidget: StudentProfileDetails(user: loggedUser),
            onRefresh: () {
              StudentProfileCubit.get(context).getLoggedUser();
            },
            onLogout: () async {
              await StudentProfileCubit.get(context).logout();
              final destination = await AppLogout.destinationAfterLogout();
              if (!context.mounted) return;
              MyNavigator.goToOffAll(context, destination);
            },
          ),
        );
      },
    );
  }

  String _studentSubtitle(BuildContext context, LoggedUserModel loggedUser) {
    final grade = loggedUser.grade?.name.trim();
    return grade?.isNotEmpty == true ? grade! : CurrentUserUi.role(context);
  }
}
