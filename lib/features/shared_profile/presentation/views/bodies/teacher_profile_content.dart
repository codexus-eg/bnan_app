import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_state.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/teacher_profile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileContent extends StatelessWidget {
  const TeacherProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
      builder: (context, state) {
        if (state is TeacherProfileFailure) {
          return Center(child: Text(state.errorMessage));
        }

        final isLoading = state is TeacherProfileLoading;
        final profile = state is TeacherProfileSuccess
            ? state.teacherProfile
            : TeacherProfileModel.placeholder();

        return AppSkeletonizer(
          isLoading: isLoading,
          child: TeacherProfileLayout(profile: profile),
        );
      },
    );
  }
}