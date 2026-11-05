import 'dart:async';

import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_url_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkifiedNotificationText extends StatefulWidget {
  const LinkifiedNotificationText({
    super.key,
    required this.text,
    this.style,
    this.urlStyle,
    this.onTapUrl,
  });

  final String text;
  final TextStyle? style;
  final TextStyle? urlStyle;
  final FutureOr<void> Function(String url)? onTapUrl;

  @override
  State<LinkifiedNotificationText> createState() =>
      _LinkifiedNotificationTextState();
}

class _LinkifiedNotificationTextState extends State<LinkifiedNotificationText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();
    final defaultStyle = widget.style ?? StylesManager.styleRegular16(context);
    final linkStyle = widget.urlStyle ??
        defaultStyle.copyWith(
          color: ColorManager.blue007,
          decoration: TextDecoration.underline,
        );

    final parts = NotificationUrlParser.parse(widget.text);
    final spans = parts.map((part) {
      if (!part.isUrl) {
        return TextSpan(text: part.text, style: defaultStyle);
      }

      final recognizer = TapGestureRecognizer()
        ..onTap = () async {
          if (widget.onTapUrl != null) {
            await widget.onTapUrl!(part.text);
          } else {
            await FileUrlLauncher.open(part.text);
          }
        };
      _recognizers.add(recognizer);

      return TextSpan(
        text: part.text,
        style: linkStyle,
        recognizer: recognizer,
      );
    }).toList();

    return Text.rich(
      TextSpan(children: spans),
      style: defaultStyle,
    );
  }
}
