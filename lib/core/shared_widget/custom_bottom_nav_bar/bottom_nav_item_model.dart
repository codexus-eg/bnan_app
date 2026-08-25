class BottomNavItemModel {
  const BottomNavItemModel({
    required this.icon,
    required this.title,
    this.tracksUnreadMessages = false,
  });

  final String icon;
  final String title;
  final bool tracksUnreadMessages;
}
