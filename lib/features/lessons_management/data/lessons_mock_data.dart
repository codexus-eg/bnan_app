
// TODO: Replace preview mock data with Cubit state after API integration.
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';

const lessonsMockData = <LessonUiModel>[
  LessonUiModel(
    id: '1',
    subjectName: 'علوم',
    classroomName: 'الصف الخامس الابتدائي',
    startTime: '09:00 ص',
    endTime: '09:40 ص',
  ),
  LessonUiModel(
    id: '2',
    subjectName: 'علوم',
    classroomName: 'الصف الخامس الابتدائي',
    startTime: '10:00 ص',
    endTime: '10:40 ص',
  ),
  LessonUiModel(
    id: '3',
    subjectName: '',
    classroomName: '',
    startTime: '11:00 ص',
    endTime: '11:40 ص',
    isEmptySlot: true,
  ),
  LessonUiModel(
    id: '4',
    subjectName: '',
    classroomName: '',
    startTime: '12:00 م',
    endTime: '12:40 م',
    isEmptySlot: true,
  ),
];
