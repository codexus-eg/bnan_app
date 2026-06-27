import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/contact_info_card.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_teacher_extra_widget.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/logout_button.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/privacy_card.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_header.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileCubit, StudentProfileState>(
      builder: (context, state) {
        final bool isLoading = state is StudentProfileStateLoading;

        final loggedUser = state is StudentProfileStateSuccess
            ? state.loggedUser
            : LoggedUserModel.placeholder();

        if (state is StudentProfileStateFailure) {
          return Center(child: Text(state.errorMessage));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            children: [
              ProfileHeader(role: loggedUser.user.role),
              Expanded(
                child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
                  children: [
                    ProfileInfoCard(loggedUser: loggedUser),
                    const SizedBox(height: 16),
                    //TODO
                    CustomTeacherExtraWidget(),
                    const SizedBox(height: 16),

                    ContactInfoCard(loggedUser: loggedUser),
                    const SizedBox(height: 16),
                    const PrivacyCard(),
                    const SizedBox(height: 16),
                    LogoutButton(
                      onTap: () async {
                        await StudentProfileCubit.get(context).logout();

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
