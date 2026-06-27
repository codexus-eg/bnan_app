import 'package:bnan_app/features/home_student/presentation/views/home_student_scaffold.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStudentView extends StatelessWidget {
  const HomeStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        StudentProfileCubit,
        StudentProfileState,
        LoggedUserModel
    >(
      selector: (state) {
        if (state is StudentProfileStateSuccess) {
          return state.loggedUser;
        }

        return LoggedUserModel.placeholder();
      },
      builder: (context, loggedUser) {
        return HomeStudentScaffold(
          loggedUser: loggedUser,
        );
      },
    );
  }
}