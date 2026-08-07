import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_form_dialog.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_codes_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountCodesBody extends StatelessWidget {
  const DiscountCodesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AddNewTopicButton(
            title: S.of(context).addDiscountCode,
            path: ImageManager.plus,
            onTap: () => showDiscountCodeForm(context),
          ),
          const SizedBox(height: 16),
          const Expanded(child: DiscountCodesContent()),
        ],
      ),
    );
  }
}
