import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/widgets/student_subscriptions_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentSubscriptionsView extends StatelessWidget {
  const StudentSubscriptionsView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).PackagesandSubscriptions),
    body: const StudentSubscriptionsBody(),
  );
}
