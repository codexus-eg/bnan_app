import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/classroom_documents_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassroomDocumentsView extends StatelessWidget {
  const ClassroomDocumentsView({
    super.key,
    required this.roomId,
    required this.roomType,
    required this.currentUserRole,
    this.classroomId,
    this.classroomName,
    this.initialTab = ClassroomDocumentsTab.recordings,
  });

  final String roomId;
  final String? roomType;
  final String? currentUserRole;
  final String? classroomId;
  final String? classroomName;
  final ClassroomDocumentsTab initialTab;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: ClassroomDocumentsBody(
          roomId: roomId,
          roomType: roomType,
          currentUserRole: currentUserRole,
          classroomId: classroomId,
          classroomName: classroomName,
          initialTab: initialTab,
        ),
      ),
    );
  }
}
