import 'package:bnan_app/features/student_schedule/presentation/views/widgets/schedule_widgets/schedule_cell.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScheduleGridTable extends StatelessWidget {
  const ScheduleGridTable({super.key});

  static const double dayColumnWidth = 58;
  static const double slotColumnWidth = 70;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final timeSlots = [
      '09:00\n09:40',
      '10:00\n10:40',
      '11:00\n11:40',
      '12:00\n12:40',
      '01:00\n01:40',
    ];

    final rows = [
      _ScheduleRow(day: s.sunday, lessons: ['${s.arabic}\n${s.teacherSarahName}', '', '${s.arabic}\n${s.teacherSarahName}', '', '']),
      _ScheduleRow(day: s.monday, lessons: ['','${s.arabic}\n${s.teacherSarahName}', '', '', '']),
      _ScheduleRow(day: s.tuesday, lessons: ['${s.arabic}\n${s.teacherSarahName}', '','${s.arabic}\n${s.teacherSarahName}', '${s.arabic}\n${s.teacherSarahName}', '']),
      _ScheduleRow(day: s.wednesday, lessons: ['', '${s.arabic}\n${s.teacherSarahName}', '', '', '']),
      _ScheduleRow(day: s.thursday, lessons: ['${s.arabic}\n${s.teacherSarahName}', '', '${s.arabic}\n${s.teacherSarahName}', '', '']),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          _HeaderRow(timeTitle: s.time, timeSlots: timeSlots),
          ...rows.map((row) {
            return _DayRow(
              row: row,
              slotsCount: timeSlots.length,
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.timeTitle,
    required this.timeSlots,
  });

  final String timeTitle;
  final List<String> timeSlots;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScheduleCell(
          text: timeTitle,
          width: ScheduleGridTable.dayColumnWidth,
          isHeader: true,
          isDark: false,
        ),
        ...timeSlots.map((slot) {
          return ScheduleCell(
            text: slot,
            width: ScheduleGridTable.slotColumnWidth,
            isHeader: true,
            isDark: true,
          );
        }),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.row,
    required this.slotsCount,
  });

  final _ScheduleRow row;
  final int slotsCount;

  @override
  Widget build(BuildContext context) {
    final lessons = _completeLessons(row.lessons, slotsCount);

    return Row(
      children: [
        ScheduleCell(
          text: row.day,
          width: ScheduleGridTable.dayColumnWidth,
          isHeader: true,
          isDark: true,
        ),
        ...lessons.map((lesson) {
          return ScheduleCell(
            text: lesson,
            width: ScheduleGridTable.slotColumnWidth,
            isHeader: false,
            isDark: false,
          );
        }),
      ],
    );
  }

  List<String> _completeLessons(List<String> lessons, int count) {
    if (lessons.length >= count) {
      return lessons.take(count).toList();
    }

    return [
      ...lessons,
      ...List.generate(count - lessons.length, (_) => ''),
    ];
  }
}

class _ScheduleRow {
  const _ScheduleRow({
    required this.day,
    required this.lessons,
  });

  final String day;
  final List<String> lessons;
}