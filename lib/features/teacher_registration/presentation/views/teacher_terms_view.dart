import 'dart:convert';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_terms_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TeacherTermsView extends StatefulWidget {
  const TeacherTermsView({super.key, required this.terms});
  final TeacherTermsModel terms;

  @override
  State<TeacherTermsView> createState() => _TeacherTermsViewState();
}

class _TeacherTermsViewState extends State<TeacherTermsView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadHtmlString(_html());
  }

  String _html() {
    final title = const HtmlEscape().convert(widget.terms.title);
    final content = const HtmlEscape()
        .convert(widget.terms.content)
        .replaceAll('\n', '<br>');
    return '''<!doctype html><html dir="rtl"><head><meta name="viewport"
content="width=device-width, initial-scale=1"><style>body{font-family:sans-serif;
padding:16px;line-height:1.9;color:#14213d}h1{font-size:22px}</style></head>
<body><h1>$title</h1><div>$content</div></body></html>''';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: widget.terms.title),
    body: WebViewWidget(controller: controller),
  );
}
