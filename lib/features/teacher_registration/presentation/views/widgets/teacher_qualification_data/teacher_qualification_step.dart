import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_qualification_fields.dart';
import 'package:flutter/material.dart';

class TeacherQualificationStep extends StatelessWidget {
  const TeacherQualificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Form(
      key: cubit.qualificationFormKey,
      child: const TeacherQualificationFields(),
    );
  }
}
