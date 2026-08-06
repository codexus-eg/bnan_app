import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:dartz/dartz.dart';

class FakeParentScheduleChildrenRepo implements ParentHomeRepo {
  FakeParentScheduleChildrenRepo(this.load);
  Future<Either<Failure, GetParentChildrenResponseModel>> Function() load;
  int calls = 0;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>> getParentChildren() {
    calls++;
    return load();
  }
}

class FakeParentEgyptianScheduleRepo implements TableManagementRepo {
  FakeParentEgyptianScheduleRepo(this.load);
  Future<Either<Failure, EgyptianSchedulesResponseModel>> Function(String? id)
  load;
  final studentIds = <String?>[];

  @override
  Future<Either<Failure, EgyptianSchedulesResponseModel>>
  getMyEgyptianSchedule({String? studentId}) {
    studentIds.add(studentId);
    return load(studentId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
