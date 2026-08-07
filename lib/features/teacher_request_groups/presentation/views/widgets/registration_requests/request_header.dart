import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/request_details.dart';
import 'package:flutter/material.dart';

class RequestHeader extends StatelessWidget {
  const RequestHeader({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomAvatar(firstName: request.studentName, radius: 25),
        const SizedBox(width: 8),
        Expanded(child: RequestDetails(request: request)),
      ],
    );
  }
}
