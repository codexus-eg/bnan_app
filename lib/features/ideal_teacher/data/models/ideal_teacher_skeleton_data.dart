import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';

const teacherRankingSkeleton = [
  TeacherRankingItemModel(
    rank: 1,
    teacherId: '1',
    fullName: 'Teacher Name',
    subjects: ['Subject'],
    weeklyPoints: 90,
  ),
  TeacherRankingItemModel(
    rank: 2,
    teacherId: '2',
    fullName: 'Teacher Name',
    subjects: ['Subject'],
    weeklyPoints: 85,
  ),
];

const supervisorTeachersSkeleton = [
  SupervisorTeacherModel(
    id: '1',
    name: 'Teacher Name Here',
    avatar: '',
    subjects: ['Subject A'],
    classrooms: ['Classroom A'],
  ),
  SupervisorTeacherModel(
    id: '2',
    name: 'Teacher Name Here',
    avatar: '',
    subjects: ['Subject B'],
    classrooms: ['Classroom B'],
  ),
];
