import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/plans/presentation/models/term_plan_card_item.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plan_card_details.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermPlanCard extends StatelessWidget {
  const TermPlanCard({super.key, required this.item});

  final TermPlanCardItem item;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkAttachmentPreview(
            attachmentUrl: item.attachment,
            title: S.of(context).termPlan,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          TermPlanCardDetails(item: item),
        ],
      ),
    );
  }
}
