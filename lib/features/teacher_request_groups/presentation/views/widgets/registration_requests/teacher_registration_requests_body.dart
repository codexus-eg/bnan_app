import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_action_listener.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRegistrationRequestsBody extends StatelessWidget {
  const TeacherRegistrationRequestsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      TeacherRegistrationRequestsCubit,
      TeacherRegistrationRequestsState
    >(
      listener: handleTeacherRequestsAction,
      builder: (context, state) => TeacherRequestsContent(state: state),
    );
  }
}
