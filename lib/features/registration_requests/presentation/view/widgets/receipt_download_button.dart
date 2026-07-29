import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReceiptDownloadButton extends StatelessWidget {
  const ReceiptDownloadButton({super.key, required this.receiptUrl});

  final String receiptUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openReceipt(context),
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Center(
          child: SvgPicture.asset(
            ImageManager.downloadIcon,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }

  Future<void> _openReceipt(BuildContext context) async {
    final opened = await FileUrlLauncher.open(receiptUrl);
    if (!opened && context.mounted) {
      showCustomSnackBar(
        context,
        S.of(context).unableToOpenPaymentReceipt,
        false,
      );
    }
  }
}
