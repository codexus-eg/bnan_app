import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_link_opener.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_next_steps.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SummaryDetailsContent extends StatelessWidget {
  const SummaryDetailsContent({super.key, required this.item});
  final ClassroomSummaryItemModel item;

  @override
  Widget build(BuildContext context) {
    final summary = item.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.sessionName.isNotEmpty)
          Text(item.sessionName, style: StylesManager.styleRegular14(context)),
        const SizedBox(height: 8),
        Text(
          summary?.title ?? S.of(context).sessionSummary,
          style: StylesManager.styleBold20(context),
        ),
        const SizedBox(height: 16),
        Text(
          summary?.content ?? S.of(context).noSummaryContent,
          style: StylesManager.styleRegular16(context),
        ),
        if (summary?.nextSteps.isNotEmpty == true)
          SummaryNextSteps(steps: summary!.nextSteps),
        if (summary?.docUrl != null) ...[
          const SizedBox(height: 24),
          CustomAppButton(
            text: S.of(context).openDocument,
            onPressed: () => openDocumentLink(context, summary!.docUrl),
          ),
        ],
      ],
    );
  }
}
