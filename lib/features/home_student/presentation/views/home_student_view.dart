import 'package:bnan_app/features/home_student/presentation/views/home_student_scaffold.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStudentView extends StatelessWidget {
  const HomeStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        GetLoggedUserCubit,
        GetLoggedUserState,
        LoggedUserModel
    >(
      selector: (state) {
        if (state is GetLoggedUserSuccess) {
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