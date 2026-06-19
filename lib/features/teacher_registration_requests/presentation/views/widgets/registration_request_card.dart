import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_registration_requests/presentation/views/widgets/request_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestCard extends StatelessWidget {
  const RegistrationRequestCard({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          RequestHeader(request: request),
          const SizedBox(height: 16),
          CustomAppButton(text: S.of(context).acceptRequest, onPressed: () {}),
        ],
      ),
    );
  }
}
