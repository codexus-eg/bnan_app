// import 'package:bnan_app/core/api/api_service.dart';
// import 'package:bnan_app/core/api/end_points.dart';
// import 'package:bnan_app/core/errors/failure.dart';
// import 'package:bnan_app/features/teacher_shared/data/models/teacher_classroom_student_model.dart';
// import 'package:bnan_app/features/teacher_shared/data/models/teacher_curriculum_model.dart';
// import 'package:bnan_app/features/teacher_shared/data/models/teacher_grade_model.dart';
// import 'package:bnan_app/features/teacher_shared/data/repo/teacher_shared_repo.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';

// class TeacherSharedRepoImpl implements TeacherSharedRepo {
//   final ApiService apiService;

//   TeacherSharedRepoImpl(this.apiService);

//   @override
//   Future<Either<Failure, List<TeacherCurriculumModel>>>
//       getTeacherCurriculums() async {
//     try {
//       final response = await apiService.get(
//         endPoint: EndPoints.teacherCurriculums,
//       );

//       final data = response['data']['curriculums'] as List;

//       final curriculums = data
//           .map((item) => TeacherCurriculumModel.fromJson(item))
//           .toList();

//       return right(curriculums);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioException(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<TeacherGradeModel>>> getTeacherGradesByCurriculum({
//     required String curriculumId,
//   }) async {
//     try {
//       final response = await apiService.get(
//         endPoint: EndPoints.teacherGradesByCurriculum(curriculumId),
//       );

//       final data = response['data'] as List;

//       final grades =
//           data.map((item) => TeacherGradeModel.fromJson(item)).toList();

//       return right(grades);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioException(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<TeacherClassroomStudentModel>>>
//       getTeacherClassroomStudents({
//     required String classroomId,
//   }) async {
//     try {
//       final response = await apiService.get(
//         endPoint: EndPoints.teacherClassroomStudents(classroomId),
//       );

//       final data = response['data'] as List;

//       final students = data
//           .map((item) => TeacherClassroomStudentModel.fromJson(item))
//           .toList();

//       return right(students);
//     } catch (e) {
//       if (e is DioException) {
//         return left(ServerFailure.fromDioException(e));
//       }
//       return left(ServerFailure(e.toString()));
//     }
//   }
// }