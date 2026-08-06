import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_card_shell.dart';
import 'package:flutter/material.dart';

class DocumentsSkeleton extends StatelessWidget {
  const DocumentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => AppSkeletonizer(
    isLoading: true,
    child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const DocumentCardShell(
        icon: Icons.description_outlined,
        title: 'Session title placeholder',
        subtitle: 'Document type placeholder',
      ),
    ),
  );
}
