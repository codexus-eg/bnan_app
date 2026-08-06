import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/classroom_documents_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassroomDocumentsView extends StatelessWidget {
  const ClassroomDocumentsView({
    super.key,
    required this.classroomId,
    this.classroomName,
  });

  final String classroomId;
  final String? classroomName;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: ClassroomDocumentsBody(
          classroomId: classroomId,
          classroomName: classroomName,
        ),
      ),
    );
  }
}
