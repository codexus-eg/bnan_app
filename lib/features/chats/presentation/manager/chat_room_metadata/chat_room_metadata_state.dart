import 'package:bnan_app/features/chats/data/models/chat_room_details_model.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';

class ChatRoomMetadataState {
  const ChatRoomMetadataState({
    this.roomType,
    this.classroomId,
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal,
    this.classroomSubjectAmbiguous,
  });

  factory ChatRoomMetadataState.fromArgs(ChatRouteArgs? args) =>
      ChatRoomMetadataState(
        roomType: args?.roomType,
        classroomId: args?.classroomId,
        accessScope: args?.accessScope,
        classroomSubjectId: args?.classroomSubjectId,
        canRequestTeacherWithdrawal: args?.canRequestTeacherWithdrawal,
        classroomSubjectAmbiguous: args?.classroomSubjectAmbiguous,
      );
  final String? roomType, classroomId, accessScope, classroomSubjectId;
  final bool? canRequestTeacherWithdrawal, classroomSubjectAmbiguous;
  bool get needsLoad {
    final type = roomType?.trim().toLowerCase();
    if (type == null || type.isEmpty) return true;
    if (type != 'classroom') return false;
    return classroomId?.trim().isEmpty != false ||
        accessScope?.trim().isEmpty != false ||
        classroomSubjectId?.trim().isEmpty != false ||
        canRequestTeacherWithdrawal == null ||
        classroomSubjectAmbiguous == null;
  }

  ChatRoomMetadataState merge(ChatRoomDetailsModel room) =>
      ChatRoomMetadataState(
        roomType: _text(room.type) ?? roomType,
        classroomId: room.classroomId ?? classroomId,
        accessScope: room.accessScope ?? accessScope,
        classroomSubjectId: room.classroomSubjectId ?? classroomSubjectId,
        canRequestTeacherWithdrawal:
            room.canRequestTeacherWithdrawal ?? canRequestTeacherWithdrawal,
        classroomSubjectAmbiguous:
            room.classroomSubjectAmbiguous ?? classroomSubjectAmbiguous,
      );
  static String? _text(String? value) =>
      value?.trim().isNotEmpty == true ? value!.trim() : null;
}
