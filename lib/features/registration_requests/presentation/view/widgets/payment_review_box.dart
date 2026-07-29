import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/payment_status_chip.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/receipt_download_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentReviewBox extends StatelessWidget {
  const PaymentReviewBox({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final paymentStatusText = request.isPaymentConfirmed
        ? s.paymentCompleted
        : s.waitingForReceiptReview;
    final receiptUrl = request.payment?.receiptImage?.trim() ?? '';
    final canOpenReceipt =
        request.registrationStatus == 'approved' &&
        request.isPaymentConfirmed &&
        receiptUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 4,
        top: 4,
        end: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.paymentStatus,
                      style: StylesManager.styleBold10(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                    if (request.paymentAmount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${s.amount} ${request.paymentAmount}',
                        style: StylesManager.styleRegular10(
                          context,
                        ).copyWith(color: ColorManager.greyA8AF),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              PaymentStatusChip(text: paymentStatusText),
              if (canOpenReceipt) ...[
                const SizedBox(width: 8),
                ReceiptDownloadButton(receiptUrl: receiptUrl),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
