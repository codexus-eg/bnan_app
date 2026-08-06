import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summary_details_content.dart';
import 'package:flutter/material.dart';

class SummaryDetailsSheet extends StatelessWidget {
  const SummaryDetailsSheet({super.key, required this.item});
  final ClassroomSummaryItemModel item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .86,
        ),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  color: ColorManager.greyD9D9,
                ),
              ),
              const SizedBox(height: 20),
              SummaryDetailsContent(item: item),
            ],
          ),
        ),
      ),
    );
  }
}
