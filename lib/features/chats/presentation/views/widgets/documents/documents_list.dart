import 'package:flutter/material.dart';

class DocumentsList extends StatelessWidget {
  const DocumentsList({
    super.key,
    required this.count,
    required this.builder,
    required this.refresh,
  });
  final int count;
  final IndexedWidgetBuilder builder;
  final Future<void> Function() refresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: refresh,
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: builder,
    ),
  );
}
