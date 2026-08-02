import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_page.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_placeholder_page.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/parent_profile_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentHomeContent extends StatelessWidget {
  const ParentHomeContent({
    super.key,
    required this.index,
    required this.onMenuTap,
    required this.onShowAllChildren,
  });

  final int index;
  final VoidCallback onMenuTap;
  final VoidCallback onShowAllChildren;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final pages = [
      ParentHomePage(
        onMenuTap: onMenuTap,
        onShowAllChildren: onShowAllChildren,
      ),
      const ParentChildrenBody(),
      ParentPlaceholderPage(title: s.parentMessages),
      ParentPlaceholderPage(title: s.parentSubscriptions),
      const ParentProfileBody(),
    ];

    return BlocProvider(
      create: (_) => getIt<GetParentChildrenCubit>()..getParentChildren(),
      child: IndexedStack(index: index, children: pages),
    );
  }
}
