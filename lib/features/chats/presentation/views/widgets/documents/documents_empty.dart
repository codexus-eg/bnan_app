import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:flutter/material.dart';

class DocumentsEmptyView extends StatelessWidget {
  const DocumentsEmptyView({
    super.key,
    required this.title,
    required this.refresh,
  });
  final String title;
  final Future<void> Function() refresh;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, constraints) => RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: NoDataWidget(title: title),
        ),
      ),
    ),
  );
}
