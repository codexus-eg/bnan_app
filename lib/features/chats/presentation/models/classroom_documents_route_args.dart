import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';

class ClassroomDocumentsRouteArgs {
  const ClassroomDocumentsRouteArgs({
    required this.roomId,
    required this.roomType,
    required this.currentUserRole,
    this.classroomId,
    this.classroomName,
    this.initialTab = ClassroomDocumentsTab.recordings,
  });

  final String roomId;
  final String? classroomId;
  final String? roomType;
  final String? currentUserRole;
  final String? classroomName;
  final ClassroomDocumentsTab initialTab;
}
