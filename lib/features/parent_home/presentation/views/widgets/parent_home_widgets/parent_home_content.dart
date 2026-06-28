import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_page.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_placeholder_page.dart';
import 'package:flutter/material.dart';

class ParentHomeContent extends StatelessWidget {
  const ParentHomeContent({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ParentHomePage(onMenuTap: onMenuTap),
      const ParentPlaceholderPage(title: 'أبناؤك'),
      const ParentPlaceholderPage(title: 'الرسائل'),
      const ParentPlaceholderPage(title: 'الاشتراكات'),
      const ParentPlaceholderPage(title: 'حسابي'),
    ];

    return pages[index];
  }
}
