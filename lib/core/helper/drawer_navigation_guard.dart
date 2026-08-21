class DrawerNavigationGuard {
  bool _handled = false;

  bool begin() {
    if (_handled) return false;
    _handled = true;
    return true;
  }

  void drawerChanged(bool isOpened) {
    if (isOpened) _handled = false;
  }
}
