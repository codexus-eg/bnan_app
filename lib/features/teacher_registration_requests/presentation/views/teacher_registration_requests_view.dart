import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_registration_requests/presentation/views/widgets/teacher_registration_requests_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationRequestsView extends StatelessWidget {
  const TeacherRegistrationRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).registrationRequests,
        iconNeeded: true,
      ),
      body: TeacherRegistrationRequestsBody(),
    );
  }
}
