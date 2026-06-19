import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_chip.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomFilterTabs<T> extends StatelessWidget {
  const CustomFilterTabs({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  final Map<T, String> items;
  final T selectedItem;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: items.entries.map((entry) {
          return CustomFilterChip(
            title: entry.value,
            isSelected: selectedItem == entry.key,
            onTap: () => onChanged(entry.key),
          );
        }).toList(),
      ),
    );
  }
}