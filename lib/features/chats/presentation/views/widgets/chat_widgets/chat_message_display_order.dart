part of 'chat_messages_list.dart';

List<ChatMessageModel> _orderedMessages(List<ChatMessageModel> messages) {
  if (messages.length < 2 ||
      messages.any((message) => message.createdAt == null)) {
    return messages;
  }

  final indexed = messages.indexed.toList();
  indexed.sort((left, right) {
    final byDate = left.$2.createdAt!.compareTo(right.$2.createdAt!);
    return byDate != 0 ? byDate : left.$1.compareTo(right.$1);
  });

  return indexed.map((entry) => entry.$2).toList(growable: false);
}
