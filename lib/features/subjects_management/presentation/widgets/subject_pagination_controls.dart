import 'package:bnan_app/core/shared_widget/compact_action_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectPaginationControls extends StatelessWidget {
  const SubjectPaginationControls({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int lastPage;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    if (lastPage <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CompactActionButton(
            title: S.of(context).previous,
            onTap: currentPage > 1 && !isLoading ? onPrevious : null,
          ),
          const SizedBox(width: 16),
          Text('$currentPage', style: StylesManager.styleBold12(context)),
          const SizedBox(width: 16),
          CompactActionButton(
            title: S.of(context).next,
            onTap: currentPage < lastPage && !isLoading ? onNext : null,
          ),
        ],
      ),
    );
  }
}
