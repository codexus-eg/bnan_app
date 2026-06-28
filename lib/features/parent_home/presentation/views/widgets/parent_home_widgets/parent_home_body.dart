import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_content.dart';
import 'package:flutter/material.dart';

class ParentHomeBody extends StatelessWidget {
  const ParentHomeBody({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return ParentHomeContent(index: index, onMenuTap: onMenuTap);
  }
}
