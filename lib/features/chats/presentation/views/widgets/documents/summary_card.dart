import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_card_shell.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_details_sheet.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.item});
  final ClassroomSummaryItemModel item;

  @override
  Widget build(BuildContext context) {
    final fallback = S.of(context).sessionSummary;
    return DocumentCardShell(
      icon: Icons.description_outlined,
      title: item.sessionName.isEmpty ? fallback : item.sessionName,
      subtitle: item.summary?.title ?? fallback,
      preview: item.summary?.content,
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SummaryDetailsSheet(item: item),
      ),
    );
  }
}
