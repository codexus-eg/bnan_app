import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_pagination_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_response_model.dart';

RegistrationRequestModel request(String id) => RegistrationRequestModel(
  requestId: id,
  subjectRequestId: 'subject-$id',
  studentId: 'student-$id',
  studentName: 'Student $id',
  curriculumId: 'curriculum',
  curriculumName: 'Saudi',
  gradeId: 'grade',
  gradeName: 'Grade 7',
  subjectId: 'subject',
  subjectName: 'Math',
  requestStatus: 'pending',
);

TeacherRequestsResponseModel page(
  int current,
  int last,
  List<RegistrationRequestModel> requests,
) => TeacherRequestsResponseModel(
  requests: requests,
  pagination: TeacherRequestsPaginationModel(
    currentPage: current,
    lastPage: last,
  ),
);
