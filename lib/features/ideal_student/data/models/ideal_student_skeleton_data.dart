import 'package:bnan_app/features/ideal_student/data/models/ideal_student_item_model.dart';

const idealStudentSkeleton = IdealStudentItemModel(
  name: 'Student name',
  gradeLabel: 'Classroom name',
  weeklyPoints: 96,
  rank: 1,
);

const idealStudentRankingSkeleton = [
  idealStudentSkeleton,
  IdealStudentItemModel(name: 'Student name', weeklyPoints: 85, rank: 2),
  IdealStudentItemModel(name: 'Student name', weeklyPoints: 80, rank: 3),
];
