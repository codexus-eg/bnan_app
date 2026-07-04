import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_request_card.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsBody extends StatelessWidget {
  const RegistrationRequestsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemBuilder: (context, index) {
        return RegistrationRequestCard(
          requestModel: requests[index],
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemCount: requests.length,
    );
  }
}
