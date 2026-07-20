import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';

const mockGrades = [
  GradeModel(
    id: '1',
    name: 'Grade 7',
    isActive: true,
    curriculum: GradeCurriculumModel(
      id: '1',
      name: 'Saudi',
      icon: '',
    ),
    subjects: [
      GradeSubjectModel(
        id: '1',
        name: 'Math',
      ),
      GradeSubjectModel(
        id: '2',
        name: 'English',
      ),
      GradeSubjectModel(
        id: '3',
        name: 'ICT',
      ),
    ],
  ),
  GradeModel(
    id: '2',
    name: 'Grade 8',
    isActive: true,
    curriculum: GradeCurriculumModel(
      id: '2',
      name: 'Egyptian',
      icon: '',
    ),
    subjects: [
      GradeSubjectModel(
        id: '4',
        name: 'Physics',
      ),
      GradeSubjectModel(
        id: '5',
        name: 'Chemistry',
      ),
    ],
  ),
  GradeModel(
    id: '3',
    name: 'Grade 9',
    isActive: true,
    curriculum: null,
    subjects: [],
  ),
];