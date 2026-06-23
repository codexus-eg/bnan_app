import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_personal_info_fields.dart';
import 'package:flutter/material.dart';

class TeacherPersonalInfoStep extends StatelessWidget {
  const TeacherPersonalInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Form(
      key: cubit.personalInfoFormKey,
      child: const TeacherPersonalInfoFields(),
    );
  }
}
