import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TamaraVerificationLoading extends StatelessWidget {
  const TamaraVerificationLoading({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: ColorManager.white,
    child: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: ColorManager.mainColor14),
              const SizedBox(height: 16),
              Text(
                S.of(context).paymentVerificationPending,
                textAlign: TextAlign.center,
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
