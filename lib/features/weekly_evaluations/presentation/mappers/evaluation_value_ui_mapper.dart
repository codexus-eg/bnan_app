import 'package:flutter/widgets.dart';

String evaluationValueLabel(BuildContext context, String value) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final labels = isArabic ? _arabic : _english;
  return labels[value] ?? value;
}

String evaluationStatusLabel(BuildContext context, bool isEvaluated) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  if (isEvaluated) return isArabic ? 'تم التقييم' : 'Evaluated';
  return isArabic ? 'لم يتم التقييم' : 'Not evaluated';
}

const _english = {
  'present': 'Present',
  'absent': 'Absent',
  'late': 'Late',
  'excused': 'Excused',
  'excellent': 'Excellent',
  'very_good': 'Very Good',
  'good': 'Good',
  'acceptable': 'Acceptable',
  'weak': 'Weak',
};

const _arabic = {
  'present': 'حاضر',
  'absent': 'غائب',
  'late': 'متأخر',
  'excused': 'غياب بعذر',
  'excellent': 'ممتاز',
  'very_good': 'جيد جدًا',
  'good': 'جيد',
  'acceptable': 'مقبول',
  'weak': 'ضعيف',
};
