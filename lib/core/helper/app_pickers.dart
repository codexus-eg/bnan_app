import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class AppPickers {
  AppPickers._();

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2035),
      initialDate: initialDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.mainColor15,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorManager.mainColor15,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.mainColor15,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              headerBackgroundColor: ColorManager.mainColor15,
              headerForegroundColor: Colors.white,
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.mainColor15,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorManager.mainColor15,
              secondary: ColorManager.mainColor15,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.mainColor15,
              ),
            ),
            timePickerTheme: _timePickerTheme(),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<int?> pickYear({
    required BuildContext context,
    required String title,
    int? selectedYear,
    int firstYear = 1970,
    int? lastYear,
  }) {
    final endYear = lastYear ?? DateTime.now().year;

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: endYear - firstYear + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    final year = endYear - index;
                    final isSelected = year == selectedYear;

                    return InkWell(
                      onTap: () => Navigator.pop(context, year),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.mainColor15
                              : ColorManager.greyF4F6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static TimePickerThemeData _timePickerTheme() {
    return TimePickerThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? const Color(0xffDCE8FB)
            : const Color(0xffF2F2F2);
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? ColorManager.mainColor15
            : Colors.black87;
      }),
      dialHandColor: ColorManager.mainColor15,
      dialBackgroundColor: ColorManager.black21.withAlpha((255 * .08).round()),
      dialTextColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? Colors.white
            : Colors.black;
      }),
      entryModeIconColor: ColorManager.mainColor15,
    );
  }
}
