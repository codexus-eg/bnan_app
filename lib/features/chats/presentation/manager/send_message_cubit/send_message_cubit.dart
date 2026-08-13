import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit(this.chatRepo) : super(SendMessageInitial());

  final ChatRepo chatRepo;

  Future<void> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  }) async {
    if (isClosed) return;
    final trimmedText = text?.trim();

    final hasText = trimmedText != null && trimmedText.isNotEmpty;
    final hasAttachments =
        attachmentPaths != null && attachmentPaths.isNotEmpty;

    if (!hasText && !hasAttachments) {
      return;
    }

    emit(SendMessageLoading());

    final result = await chatRepo.sendMessage(
      roomId: roomId,
      text: hasText ? trimmedText : null,
      attachmentPaths: hasAttachments ? attachmentPaths : null,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(SendMessageFailure(errorMessage: failure.message));
      },
      (response) {
        emit(SendMessageSuccess(message: response.message));
      },
    );
  }

  Future<void> sendTextMessage({
    required String roomId,
    required String text,
  }) async {
    await sendMessage(roomId: roomId, text: text);
  }

  Future<void> sendFiles({
    required String roomId,
    required List<String> filePaths,
    String? text,
  }) async {
    await sendMessage(roomId: roomId, text: text, attachmentPaths: filePaths);
  }

  Future<void> sendVoice({
    required String roomId,
    required String voicePath,
  }) async {
    await sendMessage(roomId: roomId, attachmentPaths: [voicePath]);
  }

  void resetState() {
    if (isClosed) return;
    emit(SendMessageInitial());
  }
}
