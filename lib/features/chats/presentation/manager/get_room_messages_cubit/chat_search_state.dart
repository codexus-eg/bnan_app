class ChatSearchState {
  const ChatSearchState({
    this.isSearching = false,
    this.searchQuery = '',
    this.resultMessageIds = const [],
    this.currentIndex = -1,
  });

  final bool isSearching;
  final String searchQuery;
  final List<String> resultMessageIds;
  final int currentIndex;

  String? get targetMessageId =>
      (currentIndex >= 0 && currentIndex < resultMessageIds.length)
      ? resultMessageIds[currentIndex]
      : null;

  ChatSearchState copyWith({
    bool? isSearching,
    String? searchQuery,
    List<String>? resultMessageIds,
    int? currentIndex,
  }) => ChatSearchState(
    isSearching: isSearching ?? this.isSearching,
    searchQuery: searchQuery ?? this.searchQuery,
    resultMessageIds: resultMessageIds ?? this.resultMessageIds,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}
