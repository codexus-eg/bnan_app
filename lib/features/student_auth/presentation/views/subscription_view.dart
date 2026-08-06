import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({
    super.key,
    required this.curriculumId,
    required this.curriculumName,
    this.registrationMode,
  });
  final String curriculumId;
  final String curriculumName;
  final String? registrationMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).packages),
      body: SubscriptionBody(
        curriculumId: curriculumId,
        curriculumName: curriculumName,
        registrationMode: registrationMode,
      ),
    );
  }
}
