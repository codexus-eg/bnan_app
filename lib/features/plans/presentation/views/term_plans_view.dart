import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermPlansView extends StatelessWidget {
  const TermPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: CustomAppbar(headerText: S.of(context).termPlan),
      body: const TermPlansBody(),
    );
  }
}
