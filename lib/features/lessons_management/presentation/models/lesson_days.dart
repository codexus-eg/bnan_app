import 'package:bnan_app/generated/l10n.dart';

const lessonDays = [
  'saturday',
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
];

String lessonDayLabel(S s, String day) => switch (day) {
  'saturday' => s.saturday,
  'sunday' => s.sunday,
  'monday' => s.monday,
  'tuesday' => s.tuesday,
  'wednesday' => s.wednesday,
  'thursday' => s.thursday,
  'friday' => s.friday,
  _ => day,
};
