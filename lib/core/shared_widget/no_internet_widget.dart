import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
    required this.isChecking,
    required this.onRetry,
  });

  final bool isChecking;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: SizedBox(
                        height: 250,
                        child: EmptyStateWidget(
                          image: ImageManager.noInternet,
                          title: S.of(context).noInternetConnection,
                          titleStyle: StylesManager.styleBold20(context)
                              .copyWith(
                                color: ColorManager.grey7D7D,
                                decoration: TextDecoration.none,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: CustomAppButton(
                  text: S.of(context).retry,
                  isLoading: isChecking,
                  onPressed: onRetry,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(decoration: TextDecoration.none),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
