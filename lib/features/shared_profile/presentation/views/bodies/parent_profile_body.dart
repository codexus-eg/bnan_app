import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentProfileBody extends StatelessWidget {
  const ParentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSystemui(
      child: Stack(
        children: [
          const ProfileBlueBackground(),
          SafeArea(child: _content(context)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return BlocBuilder<StudentProfileCubit, StudentProfileState>(
      builder: (context, state) {
        final profile = state is StudentProfileStateSuccess
            ? state.loggedUser.user
            : null;
        final session = SessionManager.instance;
        final name = profile?.fullName.trim().isNotEmpty == true
            ? profile!.fullName
            : CurrentUserUi.name(context);
        final apiPhone = profile?.phone.trim();
        return AppSkeletonizer(
          isLoading: state is StudentProfileStateLoading,
          child: ProfileLayout(
            fullName: name,
            email: profile?.email ?? session.userEmail ?? '',
            phone: apiPhone?.isNotEmpty == true
                ? apiPhone!
                : session.userPhone ?? '',
            roleLabel: CurrentUserUi.role(context),
            subtitle: CurrentUserUi.role(context),
            onRefresh: () =>
                context.read<StudentProfileCubit>().getLoggedUser(),
            onLogout: () => _logout(context),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    await AppLogout.perform(context);
  }
}
