import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal = false,
    this.classroomSubjectAmbiguous = false,
    this.classroomName,
    this.currentUserRole,
    this.studentId,
    this.targetMessageId,
  });

  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool canRequestTeacherWithdrawal;
  final bool classroomSubjectAmbiguous;
  final String? classroomName;
  final String? currentUserRole;
  final String? studentId;
  final String? targetMessageId;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ChatBody(
          roomId: roomId,
          roomType: roomType,
          classroomId: classroomId,
          accessScope: accessScope,
          classroomSubjectId: classroomSubjectId,
          canRequestTeacherWithdrawal: canRequestTeacherWithdrawal,
          classroomSubjectAmbiguous: classroomSubjectAmbiguous,
          classroomName: classroomName,
          currentUserRole: currentUserRole,
          studentId: studentId,
          targetMessageId: targetMessageId,
        ),
      ),
    );
  }
}
