import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DocumentCardText extends StatelessWidget {
  const DocumentCardText({
    super.key,
    required this.title,
    required this.subtitle,
    this.preview,
  });
  final String title, subtitle;
  final String? preview;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: StylesManager.styleBold14(context),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: StylesManager.styleRegular12(context),
      ),
      if (preview?.isNotEmpty == true) ...[
        const SizedBox(height: 6),
        Text(
          preview!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleRegular14(context),
        ),
      ],
    ],
  );
}
