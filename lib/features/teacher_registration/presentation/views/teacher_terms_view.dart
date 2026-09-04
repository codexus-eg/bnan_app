import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/html_content_viewer.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_terms_model.dart';
import 'package:flutter/material.dart';

class TeacherTermsView extends StatelessWidget {
  const TeacherTermsView({super.key, required this.terms});
  final TeacherTermsModel terms;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: terms.title),
    body: HtmlContentViewer(
      content: terms.content,
      padding: const EdgeInsets.all(16),
    ),
  );
}
