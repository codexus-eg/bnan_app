import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:dartz/dartz.dart';

class SupervisorIdealTeacherRepoImpl implements SupervisorIdealTeacherRepo {
  const SupervisorIdealTeacherRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getTeachers() => repoGuard(() async {
    final response = await api.get(
      EndPoints.supervisorTeachers,
      isProtected: true,
    );
    return IdealTeacherParser.responseItems(response)
        .map(SupervisorTeacherModel.fromJson)
        .where((teacher) => teacher.id.isNotEmpty)
        .toList(growable: false);
  });

  @override
  issueIdealTeachers({required List<String> teacherIds, String? signerName}) =>
      repoGuard(() async {
        final name = signerName?.trim();
        await api.post(
          EndPoints.supervisorIdealTeachers,
          data: {
            'teacherIds': teacherIds,
            if (name?.isNotEmpty == true) 'signerName': name,
          },
          isProtected: true,
        );
        return unit;
      });
}
