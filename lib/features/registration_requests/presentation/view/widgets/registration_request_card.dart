import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_request_actions_section.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_request_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestCard extends StatelessWidget {
  const RegistrationRequestCard({super.key, required this.requestModel});

  final RegistrationRequestModel requestModel;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        children: [
          CardHeader(
            name: requestModel.studentName,
            phone: requestModel.parentPhone,
            subtitle: _registrationStatus(context),
          ),
          const SizedBox(height: 8),
          RegistrationRequestInfo(requestModel: requestModel),
          const SizedBox(height: 8),
          RegistrationRequestActionsSection(request: requestModel),
        ],
      ),
    );
  }

  String _registrationStatus(BuildContext context) {
    final s = S.of(context);
    return switch (requestModel.registrationStatus) {
      'approved' => s.active,
      'rejected' => s.reject,
      _ => s.pendingReview,
    };
  }
}
