import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curricula_header.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curricula_list.dart';
import 'package:flutter/material.dart';

class CurriculaBody extends StatelessWidget {
  const CurriculaBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: CurriculaHeader()),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: CurriculaList()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}