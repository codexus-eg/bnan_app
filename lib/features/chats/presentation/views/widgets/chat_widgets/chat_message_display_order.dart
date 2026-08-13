part of 'chat_messages_list.dart';

List<ChatMessageModel> _displayMessages(List<ChatMessageModel> messages) {
  final seenIds = <String>{};
  final duplicateIds = <String>{};
  final uniqueMessages = <ChatMessageModel>[];

  for (final message in _orderedMessages(messages)) {
    final id = message.id.trim();
    if (id.isEmpty || seenIds.add(id)) {
      uniqueMessages.add(message);
    } else {
      duplicateIds.add(id);
    }
  }

  assert(() {
    if (duplicateIds.isNotEmpty) {
      debugPrint(
        'Chat messages: total=${messages.length}, '
        'uniqueIds=${seenIds.length}, duplicateIds=$duplicateIds',
      );
    }
    return true;
  }());
  return uniqueMessages;
}

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
