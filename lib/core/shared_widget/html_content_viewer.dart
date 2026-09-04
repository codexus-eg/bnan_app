import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

class HtmlContentViewer extends StatelessWidget {
  const HtmlContentViewer({
    super.key,
    required this.content,
    this.padding = EdgeInsets.zero,
    this.scrollable = true,
  });

  final String content;
  final EdgeInsetsGeometry padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final textStyle = StylesManager.styleRegular16(context);
    final viewer = Html(
      data: _decodedContent,
      onLinkTap: (url, _, _) => FileUrlLauncher.open(url ?? ''),
      style: {
        'body': Style(
          color: textStyle.color,
          fontSize: FontSize(textStyle.fontSize ?? 16),
          fontWeight: textStyle.fontWeight,
        ),
      },
    );
    if (!scrollable) return Padding(padding: padding, child: viewer);
    return SingleChildScrollView(padding: padding, child: viewer);
  }

  String get _decodedContent {
    final hasHtml = RegExp(r'<\s*/?\s*[a-z][^>]*>', caseSensitive: false);
    final hasEncodedHtml = RegExp(
      r'&lt;\s*/?\s*[a-z][^>]*?&gt;',
      caseSensitive: false,
    );
    if (hasHtml.hasMatch(content) || !hasEncodedHtml.hasMatch(content)) {
      return content;
    }
    return HtmlUnescape().convert(content);
  }
}
