import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_appbar.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/subscription_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAuthAppbar(title: S.of(context).packages),
      body: SubscriptionBody(),
    );
  }
}