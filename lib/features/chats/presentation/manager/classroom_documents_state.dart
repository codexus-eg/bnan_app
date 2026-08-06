sealed class ClassroomDocumentsState<T> {
  const ClassroomDocumentsState();
}

final class DocumentsInitial<T> extends ClassroomDocumentsState<T> {
  const DocumentsInitial();
}

final class DocumentsLoading<T> extends ClassroomDocumentsState<T> {
  const DocumentsLoading();
}

final class DocumentsSuccess<T> extends ClassroomDocumentsState<T> {
  const DocumentsSuccess(this.items);
  final List<T> items;
}

final class DocumentsEmpty<T> extends ClassroomDocumentsState<T> {
  const DocumentsEmpty();
}

final class DocumentsFailure<T> extends ClassroomDocumentsState<T> {
  const DocumentsFailure(this.message);
  final String message;
}
