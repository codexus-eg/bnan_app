import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_state.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/policies/student_classroom_assignment_error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAvailableClassroomsCubit extends Cubit<GetAvailableClassroomsState> {
  GetAvailableClassroomsCubit(this.repo)
    : super(const GetAvailableClassroomsInitial());

  final StudentClassroomAssignmentRepo repo;
  String? _loadingStudentId;
  int _requestRevision = 0;

  Future<void> getAvailableClassrooms(String studentId) async {
    if (isClosed) return;
    final id = studentId.trim();
    if (id.isEmpty || id == _loadingStudentId) return;
    final revision = ++_requestRevision;
    _loadingStudentId = id;
    emit(const GetAvailableClassroomsLoading());

    final result = await repo.getAvailableClassrooms(id);
    if (isClosed || revision != _requestRevision) return;
    _loadingStudentId = null;

    result.fold(
      (failure) => emit(
        GetAvailableClassroomsFailure(mapStudentClassroomsFailure(failure)),
      ),
      (response) => emit(GetAvailableClassroomsSuccess(response)),
    );
  }

  void reset() {
    _requestRevision++;
    _loadingStudentId = null;
    emit(const GetAvailableClassroomsInitial());
  }
}
