import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpWidget extends StatefulWidget {
  final Function(String otpCode)? onCompleted;
  final VoidCallback? onResend;
  final bool isError;
  final Function(String)? onChanged;
  final TextEditingController pinController;

  const OtpWidget({
    super.key,
    this.onCompleted,
    this.onResend,
    this.isError = false,
    this.onChanged,
    required this.pinController,
  });

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    widget.pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 71,
      height: 71,
      textStyle: StylesManager.styleMedium32(
        context,
      ).copyWith(color: ColorManager.mainColor14),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255*.25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4)
          )
        ]
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.greyF8F9),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.mainColor14, width: 1.5),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.orangeED),
    );

    return Column(
      children: [
        Pinput(
          controller: widget.pinController,
          focusNode: focusNode,
          length: 4,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          forceErrorState: widget.isError,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          onCompleted: (pin) => widget.onCompleted?.call(pin),

          onChanged: (pin) {
            widget.onChanged?.call(pin);
          },
        ),
      ],
    );
  }
}
