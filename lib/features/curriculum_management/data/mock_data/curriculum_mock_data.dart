import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/generated/l10n.dart';

List<CurriculumModel> curriculumMockData(S s) {
  return [
    CurriculumModel(
      id: 'saudi',
      name: s.saudiCurriculum,
      grades: [
        GradeModel(
          id: 'saudi-third-prep',
          name: s.parentThirdPreparatoryGrade,
          semesters: [
            SemesterModel(id: 'saudi-third-1', name: s.semesterOne),
            SemesterModel(id: 'saudi-third-2', name: s.semesterTwo),
          ],
        ),
        GradeModel(
          id: 'saudi-second-prep',
          name: s.parentSecondPreparatoryGrade,
          semesters: [
            SemesterModel(id: 'saudi-second-1', name: s.semesterOne),
            SemesterModel(id: 'saudi-second-2', name: s.semesterTwo),
            SemesterModel(id: 'saudi-second-3', name: s.semesterThree),
          ],
        ),
      ],
    ),
    CurriculumModel(id: 'egyptian', name: s.egyptianCurriculum, grades: []),
  ];
}
