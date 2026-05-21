import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencySelector extends StatefulWidget {
  const CurrencySelector({super.key});

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  String selectedCurrency = 'sar';

  @override
  Widget build(BuildContext context) {
    final currencies = {
      'sar': S.of(context).sarCurrency,
      'egp': S.of(context).egpCurrency,
      'qar': S.of(context).qarCurrency,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(ImageManager.coinNumberIcon, width: 20, height: 20),
        const SizedBox(width: 8),
        Text(
          S.of(context).currency,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
        const SizedBox(width: 8),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.greyA8AF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<String>(
            value: selectedCurrency,
            underline: const SizedBox.shrink(),
            icon: const SizedBox.shrink(),
            selectedItemBuilder: (context) {
              return currencies.entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: ColorManager.greyA8AF,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.value,
                      style: StylesManager.styleLight14(context),
                    ),
                  ],
                );
              }).toList();
            },
            items: currencies.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: StylesManager.styleLight14(context),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => selectedCurrency = value);
            },
          ),
        ),
      ],
    );
  }
}
