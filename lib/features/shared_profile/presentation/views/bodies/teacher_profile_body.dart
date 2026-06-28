import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/teacher_profile_content.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileBody extends StatelessWidget {
  const TeacherProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TeacherProfileCubit>()..getTeacherProfile(),
      child: const CustomSystemui(
        child: Stack(
          children: [
            ProfileBlueBackground(),
            SafeArea(child: TeacherProfileContent()),
          ],
        ),
      ),
    );
  }
}
