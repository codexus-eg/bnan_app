import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/mappers/message_document_mapper.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageDocumentsCubit
    extends Cubit<ClassroomDocumentsState<MessageDocumentItem>> {
  MessageDocumentsCubit(this.repo) : super(const DocumentsInitial());

  final ChatRepo repo;
  int _requestId = 0;
  bool _loaded = false;

  Future<void> load(String roomId, {bool refresh = false}) async {
    if (_loaded && !refresh) return;
    final requestId = ++_requestId;
    emit(const DocumentsLoading());
    final result = await repo.getRoomMessages(roomId: roomId);
    if (isClosed || requestId != _requestId) return;
    result.fold((failure) => emit(DocumentsFailure(failure.message)), (
      response,
    ) {
      _loaded = true;
      final items = MessageDocumentMapper.fromMessages(response.messages);
      emit(items.isEmpty ? const DocumentsEmpty() : DocumentsSuccess(items));
    });
  }
}
