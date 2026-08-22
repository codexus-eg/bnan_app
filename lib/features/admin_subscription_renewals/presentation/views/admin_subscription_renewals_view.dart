import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_subscription_renewals_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminSubscriptionRenewalsView extends StatelessWidget {
  const AdminSubscriptionRenewalsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).adminSubscriptionRenewals),
    body: const AdminSubscriptionRenewalsBody(),
  );
}
