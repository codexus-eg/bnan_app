import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_body.dart';
import 'package:bnan_app/features/chats/presentation/manager/chat_room_metadata/chat_room_metadata_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/chat_room_metadata/chat_room_metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.roomId,
    this.classroomName,
    this.currentUserRole,
    this.studentId,
    this.targetMessageId,
  });

  final String roomId;
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
        body: BlocBuilder<ChatRoomMetadataCubit, ChatRoomMetadataState>(
          builder: (_, metadata) => ChatBody(
            roomId: roomId,
            roomType: metadata.roomType,
            classroomId: metadata.classroomId,
            accessScope: metadata.accessScope,
            classroomSubjectId: metadata.classroomSubjectId,
            canRequestTeacherWithdrawal: metadata.canRequestTeacherWithdrawal,
            classroomSubjectAmbiguous: metadata.classroomSubjectAmbiguous,
            classroomName: classroomName,
            currentUserRole: currentUserRole,
            studentId: studentId,
            targetMessageId: targetMessageId,
          ),
        ),
      ),
    );
  }
}
