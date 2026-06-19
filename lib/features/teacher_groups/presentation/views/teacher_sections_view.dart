import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_sections_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherSectionsView extends StatelessWidget {
  const TeacherSectionsView({super.key});

  static const routeName = '/teacher-sections';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).sections),
      body: TeacherSectionsBody(),
    );
  }
}
