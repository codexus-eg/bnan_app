import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

sealed class SendMessageState {}

final class SendMessageInitial extends SendMessageState {}

final class SendMessageLoading extends SendMessageState {}

final class SendMessageSuccess extends SendMessageState {
  SendMessageSuccess({
    required this.message,
  });

  final ChatMessageModel message;
}

final class SendMessageFailure extends SendMessageState {
  SendMessageFailure({
    required this.errorMessage,
  });

  final String errorMessage;
}