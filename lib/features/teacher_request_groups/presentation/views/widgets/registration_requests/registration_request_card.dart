import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/request_header.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_registration_request_dialogs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestCard extends StatelessWidget {
  const RegistrationRequestCard({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        children: [
          RequestHeader(request: request),
          const SizedBox(height: 16),
          CustomAppButton(
            text: S.of(context).acceptRequest,
            onPressed: () =>
                TeacherRegistrationRequestDialogs.showAcceptRequest(
                  context,
                  studentName: request.studentName,
                  onAccept: () {},
                ),
          ),
        ],
      ),
    );
  }
}
