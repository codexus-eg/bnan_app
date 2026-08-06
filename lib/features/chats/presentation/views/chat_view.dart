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
    this.classroomName,
  });

  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? classroomName;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ChatBody(
          roomId: roomId,
          roomType: roomType,
          classroomId: classroomId,
          classroomName: classroomName,
        ),
      ),
    );
  }
}
