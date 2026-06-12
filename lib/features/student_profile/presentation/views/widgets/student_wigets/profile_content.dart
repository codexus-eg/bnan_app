import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_state.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/contact_info_card.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/logout_button.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/privacy_card.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/profile_header.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/student_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLoggedUserCubit, GetLoggedUserState>(
      builder: (context, state) {
        final bool isLoading = state is GetLoggedUserLoading;

        final loggedUser = state is GetLoggedUserSuccess
            ? state.loggedUser
            : LoggedUserModel.placeholder();

        if (state is GetLoggedUserFailure) {
          return Center(child: Text(state.errorMessage));
        }

        final bool isRefreshing =
            state is GetLoggedUserSuccess && state.isRefreshing;

        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            children: [
              if (isRefreshing) const LinearProgressIndicator(minHeight: 2),
              ProfileHeader(role: loggedUser.user.role),
              Expanded(
                child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
                  children: [
                    StudentInfoCard(loggedUser: loggedUser),
                    const SizedBox(height: 16),
                    ContactInfoCard(loggedUser: loggedUser),
                    const SizedBox(height: 16),
                    const PrivacyCard(),
                    const SizedBox(height: 16),
                    LogoutButton(
                      onTap: () async {
                        await GetLoggedUserCubit.get(context).logout();

                        if (!context.mounted) return;

                        MyNavigator.goToOffAll(context, Routes.logIn);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
