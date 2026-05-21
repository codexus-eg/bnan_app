import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/currency_selector.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/subscription_header.dart';
import 'package:flutter/material.dart';

class SubscriptionBody extends StatelessWidget {
  const SubscriptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SubscriptionHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: CurrencySelector()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverPadding(
            padding: EdgeInsetsDirectional.only(start: 14, end: 18),
            sliver: SubscriptionGrid(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
