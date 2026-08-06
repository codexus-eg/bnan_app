import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomRecordingsCubit
    extends Cubit<ClassroomDocumentsState<ClassroomRecordingModel>> {
  ClassroomRecordingsCubit(this.repo) : super(const DocumentsInitial());

  final ClassroomDocumentsRepo repo;
  int _requestId = 0;
  bool _loaded = false;

  Future<void> load(String classroomId, {bool refresh = false}) async {
    if (_loaded && !refresh) return;
    final requestId = ++_requestId;
    emit(const DocumentsLoading());
    final result = await repo.getRecordings(classroomId);
    if (isClosed || requestId != _requestId) return;
    result.fold((failure) => emit(DocumentsFailure(failure.message)), (
      response,
    ) {
      _loaded = true;
      emit(
        response.items.isEmpty
            ? const DocumentsEmpty()
            : DocumentsSuccess(response.items),
      );
    });
  }
}
