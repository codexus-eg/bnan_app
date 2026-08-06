import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

// TODO: REMOVE GULF STUDENT SCHEDULE MOCK DATA BEFORE RELEASE
List<GulfClassroom> buildMockGulfStudentSchedule() => [
  _classroom('math', 'الرياضيات', const [
    GulfScheduleEntry(day: 'saturday', startTime: '09:00'),
    GulfScheduleEntry(day: 'tuesday', startTime: '11:00'),
  ]),
  _classroom('science', 'العلوم', const [
    GulfScheduleEntry(day: 'sunday', startTime: '10:00'),
  ]),
  _classroom('arabic', 'اللغة العربية', const [
    GulfScheduleEntry(day: 'saturday', startTime: '11:00'),
    GulfScheduleEntry(day: 'wednesday', startTime: '10:00'),
  ]),
  _classroom('english', 'اللغة الإنجليزية', const [
    GulfScheduleEntry(day: 'monday', startTime: '09:00'),
    GulfScheduleEntry(day: 'thursday', startTime: '12:00'),
  ]),
];

GulfClassroom _classroom(
  String id,
  String subjectName,
  List<GulfScheduleEntry> entries,
) => GulfClassroom(
  id: 'mock-$id',
  name: subjectName,
  subject: GulfSubject(id: id, name: subjectName),
  classroomSubject: 'mock-$id-subject',
  schedule: GulfSchedule(
    id: 'mock-$id-schedule',
    classroomSubject: 'mock-$id-subject',
    entries: entries,
    isActive: true,
  ),
);
