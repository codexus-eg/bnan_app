import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.pinController,
    this.onCompleted,
    this.onResend,
    this.isError = false,
    this.onChanged,
  });

  final TextEditingController pinController;
  final Function(String otpCode)? onCompleted;
  final VoidCallback? onResend;
  final bool isError;
  final Function(String)? onChanged;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 71,
      height: 71,
      textStyle: StylesManager.styleMedium32(context).copyWith(
        color: ColorManager.mainColor14,
      ),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.greyF8F9),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: ColorManager.mainColor14,
        width: 1.5,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorManager.orangeED),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: widget.pinController,
        focusNode: focusNode,
        length: 4,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        forceErrorState: widget.isError,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        keyboardType: TextInputType.number,
        onCompleted: widget.onCompleted,
        onChanged: widget.onChanged,
      ),
    );
  }
}