import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsView extends StatelessWidget {
  const RegistrationRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).registrationRequests),
      body: RegistrationRequestsBody(),
    );
  }
}
