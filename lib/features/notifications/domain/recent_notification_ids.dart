class RecentNotificationIds {
  RecentNotificationIds({
    this.capacity = 300,
    this.ttl = const Duration(minutes: 10),
  });
  final int capacity;
  final Duration ttl;
  final Map<String, DateTime> _items = {};

  bool claim(String id) {
    final value = id.trim();
    if (value.isEmpty) return true;
    final now = DateTime.now();
    _items.removeWhere((_, time) => now.difference(time) > ttl);
    if (_items.containsKey(value)) return false;
    _items[value] = now;
    while (_items.length > capacity) {
      _items.remove(_items.keys.first);
    }
    return true;
  }

  void clear() => _items.clear();
}
