import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_codes_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountCodesView extends StatelessWidget {
  const DiscountCodesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).discountCodes),
      body: const DiscountCodesBody(),
    );
  }
}
