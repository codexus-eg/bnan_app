import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_pagination_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/repo/teacher_registration_requests_repo.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_request_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_requests_accept.dart';
part 'teacher_requests_load_more.dart';
part 'teacher_requests_loading.dart';

class TeacherRegistrationRequestsCubit
    extends Cubit<TeacherRegistrationRequestsState> {
  TeacherRegistrationRequestsCubit(this.repo) : super(TeacherRequestsInitial());

  static const limit = 20;
  final TeacherRegistrationRequestsRepo repo;
  final List<RegistrationRequestModel> _requests = [];
  TeacherRequestsPaginationModel _pagination =
      const TeacherRequestsPaginationModel();
  bool _isLoadingMore = false;
  String? _acceptingRequestId;
  String? _lastClassroomId;
  String? _lastChatRoomId;

  List<RegistrationRequestModel> get requests => List.unmodifiable(_requests);
  TeacherRequestsPaginationModel get pagination => _pagination;
  String? get acceptingRequestId => _acceptingRequestId;
  String? get lastClassroomId => _lastClassroomId;
  String? get lastChatRoomId => _lastChatRoomId;

  void _emitState(TeacherRegistrationRequestsState value) {
    if (!isClosed) emit(value);
  }
}
