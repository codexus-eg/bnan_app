import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_page.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_placeholder_page.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/parent_profile_body.dart';
import 'package:bnan_app/generated/l10n.dart';
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
    final s = S.of(context);

    final pages = [
      ParentHomePage(onMenuTap: onMenuTap),
      ParentChildrenBody(),
      ParentPlaceholderPage(title: s.parentMessages),
      ParentPlaceholderPage(title: s.parentSubscriptions),
      const ParentProfileBody(),
    ];

    return pages[index];
  }
}
